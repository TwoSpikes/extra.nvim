local function selectProviderWithFt()
    local ftMap = {
        vim = 'indent',
        python = {'indent'},
        git = ''
    }
    require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
            return ftMap[filetype]
        end
    })
end

local function selectProviderWithChainByDefault()
    local ftMap = {
        vim = 'indent',
        python = {'indent'},
        git = ''
    }

    local function customizeSelector(bufnr)
        local function handleFallbackException(err, providerName)
            if type(err) == 'string' and err:match('UfoFallbackException') then
                return require('ufo').getFolds(bufnr, providerName)
            else
                return require('promise').reject(err)
            end
        end

        return require('ufo').getFolds(bufnr, 'lsp'):catch(function(err)
            return handleFallbackException(err, 'treesitter')
        end):catch(function(err)
            return handleFallbackException(err, 'indent')
        end)
    end

    require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
            return ftMap[filetype] or customizeSelector
        end
    })
end

local function selectProviderWithFunction()
    local function customizeSelector(bufnr)
        local res = {}
        table.insert(res, {startLine = 1, endLine = 3})
        table.insert(res, {startLine = 5, endLine = 10})
        return res
    end

    local ftMap = {
        vim = 'indent',
        python = {'indent'},
        git = customizeSelector
    }

    require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
            return ftMap[filetype]
        end
    })
end

local function peekOrHover()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if winid then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        local keys = {'a', 'i', 'o', 'A', 'I', 'O', 'gd', 'gr'}
        for _, k in ipairs(keys) do
            -- Add a prefix key to fire `trace` action,
            -- if Neovim is 0.8.0 before, remap yourself
            vim.keymap.set('n', k, '<CR>' .. k, {noremap = false, buffer = bufnr})
        end
    else
        vim.fn.CocActionAsync('definitionHover')
        vim.lsp.buf.hover()
    end
end

local function goPreviousClosedAndPeek()
    require('ufo').goPreviousClosedFold()
    require('ufo').peekFoldedLinesUnderCursor()
end

local function goNextClosedAndPeek()
    require('ufo').goNextClosedFold()
    require('ufo').peekFoldedLinesUnderCursor()
end

local function applyFoldsAndThenCloseAllFolds(providerName)
    require('async')(function()
        local bufnr = vim.api.nvim_get_current_buf()
        require('ufo').attach(bufnr)
        local ranges = await(require('ufo').getFolds(bufnr, providerName))
        if not vim.tbl_isempty(ranges) then
            local ok = require('ufo').applyFolds(bufnr, ranges)
            if ok then
                require('ufo').closeAllFolds()
            end
        end
    end)
end

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

local function customizeFoldText()
    require('ufo').setup({
        fold_virt_text_handler = handler
    })
end

local function customizeBufFoldText()
    local bufnr = vim.api.nvim_get_current_buf()
    require('ufo').setFoldVirtTextHandler(bufnr, handler)
end

local function inspectVirtTextForFoldedLines()
    require('ufo').setup({
        enable_get_fold_virt_text = true,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate, ctx)
            for i = lnum, endLnum do
                print('lnum: ', i, ', virtText: ', vim.inspect(ctx.get_fold_virt_text(i)))
            end
            return virtText
        end
    })
end
