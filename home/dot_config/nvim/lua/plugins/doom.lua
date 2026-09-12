local binds = {
  key_strafeleft = 16, -- q
  key_up = 17, -- w
  key_straferight = 18, -- e
  key_left = 30, -- a
  key_down = 31, -- s
  key_right = 32, -- d
}

return {
  "seandewar/actually-doom.nvim",
  lazy = false,
  opts = {
    game = {
      kitty_graphics = true,
      tmux_passthrough = true,
    },
  },
  config = function(_, opts)
    require("actually-doom").setup(opts)

    local Doom = require("actually-doom.game").Doom
    local enable_kitty = Doom.enable_kitty
    function Doom:enable_kitty(on)
      enable_kitty(self, on)
      for name, scancode in pairs(binds) do
        self:send_set_config_var(name, tostring(scancode))
      end
    end
  end,
}
