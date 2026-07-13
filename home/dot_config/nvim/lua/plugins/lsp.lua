return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        -- Lua
        "lua-language-server",
        "stylua",
        -- Go
        "goimports",
        "golangci-lint",
        "gomodifytags",
        "gopls",
        "gotests",
        "iferr",
        "impl",
        -- Terraform & Terragrunt
        "terraform-ls",
        "terragrunt-ls",
        -- Shell & Bash
        "bash-language-server",
        "fish-lsp",
        "shellcheck",
        "shfmt",
        -- YAML
        "yaml-language-server",
        -- JSON
        "json-lsp",
        -- Markdown
        "marksman",
        -- Docker
        "dockerfile-language-server",
        "docker-compose-language-service",
        "hadolint",
        -- TypeScript/JavaScript
        "vtsls",
        "prettierd",
        -- Python
        "ty",
        "ruff",
        -- Helm
        "helm-ls",
        -- TOML
        "taplo",
        -- OPA
        "regols",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
    },
    config = function(_, opts)
      local mti = require("mason-tool-installer")
      mti.setup(opts)
      -- The plugin's startup install is wired to a VimEnter autocmd in its plugin/
      -- file, which never fires under lazy-loading (VeryLazy runs after VimEnter).
      -- Trigger it explicitly so tools auto-install on a fresh start.
      mti.run_on_start()
    end,
  },

  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              analyses = { unusedparams = true },
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = { globals = { "vim", "Snacks", "MiniIcons", "MiniFiles" } },
              hint = { enable = false },
            },
          },
        },
        terraformls = {},
        terragrunt_ls = {},
        helm_ls = {},
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          before_init = function(_, new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = {
                enable = false,
                url = "",
              },
            },
          },
        },
        jsonls = {
          before_init = function(_, new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = { enable = true },
              validate = { enable = true },
            },
          },
        },
        ty = {
          -- Astral's Python type checker (replaces pyright/basedpyright).
        },
        ruff = {
          -- Astral's linter + formatter + organize-imports as an LSP.
          -- Disable hover so `ty` provides type info instead.
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
          end,
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
        },
        vtsls = {
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = { enableServerSideFuzzyMatch = true },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        dockerls = {},
        docker_compose_language_service = {},
        fish_lsp = {},
        bashls = {},
        marksman = {},
        taplo = {},
        regols = {},
      }

      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      local enabled = {}
      for name in pairs(servers) do
        table.insert(enabled, name)
      end
      vim.lsp.enable(enabled)
    end,
  },
}
