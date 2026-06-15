return {
  {
    "alker0/chezmoi.vim",
    lazy = false,
    cond = function()
      return vim.fn.executable("chezmoi") == 1
    end,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
      vim.g["chezmoi#source_dir_path"] = vim.fn.expand("~") .. "/.local/share/chezmoi"
      vim.keymap.set("n", "<leader>sz", function()
        Snacks.picker.files({ cwd = vim.fn.expand("~") .. "/.local/share/chezmoi/home/" })
      end, { silent = true, desc = "Chezmoi config" })
    end,
  },
}
