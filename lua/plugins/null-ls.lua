return {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
        "mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "hadolint" })
        end,
      },
    opts = function(_, opts)
      local null_ls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        null_ls.builtins.diagnostics.hadolint,
        -- null_ls.builtins.formatting.terraform_fmt,
        -- null_ls.builtins.formatting.terraform_validate,
      })
    end
}