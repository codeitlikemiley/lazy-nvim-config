return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "b0o/SchemaStore.nvim",
        version = false, -- last release is way too old
    },
    opts = {
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
            keys = {
              { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
              { "<leader>cR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
            },
            settings = {
              typescript = {
                format = {
                  indentSize = vim.o.shiftwidth,
                  convertTabsToSpaces = vim.o.expandtab,
                  tabSize = vim.o.tabstop,
                },
              },
              javascript = {
                format = {
                  indentSize = vim.o.shiftwidth,
                  convertTabsToSpaces = vim.o.expandtab,
                  tabSize = vim.o.tabstop,
                },
              },
              completions = {
                completeFunctionCalls = true,
              },
            },
        },
        tailwindcss = {
            filetypes_exclude = { "markdown" },
        },
        terraformls = {},
        jsonls = {
            -- lazy-load schemastore when needed
            on_new_config = function(new_config)
              new_config.settings.json.schemas = new_config.settings.json.schemas or {}
              vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
            end,
            settings = {
              json = {
                format = {
                  enable = true,
                },
                validate = { enable = true },
              },
            },
        },
        dockerls = {},
        docker_compose_language_service = {},
        -- Ensure mason installs the server
        rust_analyzer = {
          keys = {
            { "K", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
            { "<leader>cR", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
            { "<leader>dr", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
          },
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
            require("typescript").setup({ server = opts })
            return true
        end,
        rust_analyzer = function(_, opts)
          local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
          require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
          return true
        end,
        tailwindcss = function(_, opts)
            local tw = require("lspconfig.server_configurations.tailwindcss")
            --- @param ft string
            opts.filetypes = vim.tbl_filter(function(ft)
              return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
            end, tw.default_config.filetypes)
          end,
      },
    },
}