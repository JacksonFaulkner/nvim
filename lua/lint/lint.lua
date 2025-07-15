-- Configuration for SQL linting with sqlfluff
local M = {}

M.setup = function()
    local lint = require("lint")
    
    -- Configure sqlfluff for SQL files with BigQuery dialect and Jinja templating
    lint.linters.sqlfluff = {
        cmd = "sqlfluff",
        args = {
            "lint",
            "--dialect", "bigquery",
            "--templater", "jinja",
            "--format", "json",
            "-" -- Read from stdin
        },
        stdin = true,
        stream = "stdout",
        ignore_exitcode = true, -- sqlfluff returns non-zero on lint findings
        parser = function(output, bufnr)
            local diagnostics = {}
            
            -- Parse the JSON output from sqlfluff
            local ok, file_results = pcall(function() 
                -- Use vim.fn.json_decode instead of vim.json.decode for better compatibility
                return vim.fn.json_decode(output)
            end)
            
            if not ok or type(file_results) ~= "table" or vim.tbl_isempty(file_results) then
                return diagnostics
            end
            
            -- sqlfluff with --format json outputs an array of violations for each file
            local violations = file_results[1]
            if type(violations) ~= "table" then return diagnostics end
            
            for _, issue in ipairs(violations) do
                table.insert(diagnostics, {
                    source = "sqlfluff",
                    lnum = issue.line_no - 1, -- nvim-lint expects 0-indexed line numbers
                    col = issue.line_pos - 1, -- nvim-lint expects 0-indexed columns
                    end_lnum = issue.line_no - 1,
                    end_col = (issue.line_pos - 1) + (issue.segment_length or 1),
                    severity = issue.level == "warning" and vim.diagnostic.severity.WARN or vim.diagnostic.severity.ERROR,
                    message = issue.description .. (issue.name and (" (" .. issue.name .. ")") or ""),
                    code = issue.code,
                })
            end
            return diagnostics
        end,
    }
    
    -- Configure which linters to use for which filetypes
    lint.linters_by_ft = {
        sql = { "sqlfluff" },
        ["sql.jinja"] = { "sqlfluff" }, -- If you use sql.jinja filetype
    }
    
    -- Create autocmd to trigger linting
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim_lint_group", { clear = true }),
        pattern = { "*.sql", "*.sql.jinja" },
        callback = function()
            require("lint").try_lint()
        end,
    })
    
    -- Optional: Print confirmation that linting is configured
    vim.notify("SQL linting configured with sqlfluff", vim.log.levels.INFO)
end

return M
