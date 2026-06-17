if vim.fn.executable("terraform") ~= 1 then
  return {}
end

return {
  -- Mason: tflint for linting (installed via mason-tool-installer)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tflint" })
    end,
  },

  -- Lint terraform files via terraform_validate
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.terraform = { "terraform_validate" }
      opts.linters_by_ft.tf = { "terraform_validate" }
    end,
  },

  -- Conform: extend formatter coverage to tf / terraform-vars + packer_fmt for plain HCL
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.terraform = { "terraform_fmt" }
      opts.formatters_by_ft.tf = { "terraform_fmt" }
      opts.formatters_by_ft["terraform-vars"] = { "terraform_fmt" }
    end,
  },
}

