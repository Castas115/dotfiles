return {
  {
    "goolord/alpha-nvim",
    dependencies = { 'echasnovski/mini.icons', 'nvim-tree/nvim-web-devicons' },

    config = function()
      local function darken(color, percent)
        -- Convert the color to RGB
        local r = tonumber(color:sub(2, 3), 16)
        local g = tonumber(color:sub(4, 5), 16)
        local b = tonumber(color:sub(6, 7), 16)

        -- Adjust the brightness
        r = math.floor(r * (1 - percent / 100))
        g = math.floor(g * (1 - percent / 100))
        b = math.floor(b * (1 - percent / 100))

        -- Return the new color
        return string.format("#%02X%02X%02X", r, g, b)
      end

      local mocha = require("catppuccin.palettes").get_palette("mocha")
      local dashboard = require("alpha.themes.dashboard")

      local function getLen(str, start_pos)
        local byte = string.byte(str, start_pos)
        if not byte then
          return nil
        end
        return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
      end

      local function colorize(header, header_color_map, colors)
        for letter, color in pairs(colors) do
          local color_name = "AlphaColor" .. letter
          vim.api.nvim_set_hl(0, color_name, color)
          colors[letter] = color_name
        end

        local colorized = {}

        for i, line in ipairs(header_color_map) do
          local colorized_line = {}
          local pos = 0

          for j = 1, #line do
            local start = pos
            pos = pos + getLen(header[i], start + 1)

            local color_name = colors[line:sub(j, j)]
            if color_name then
              table.insert(colorized_line, { color_name, start, pos })
            end
          end

          table.insert(colorized, colorized_line)
        end

        return colorized
      end

      local color_map = {
        [[      AAAA]],
        [[AAAAAA  AAAA]],
        [[AA    AAAA  AAAA        KKHHKKHHHH]],
        [[AAAA    AAAA  AA    HHBBKKKKKKKKKKKKKK]],
        [[  AAAAAA      AAKKBBHHKKBBYYBBKKKKHHKKKKKK]],
        [[      AAAA  BBAAKKHHBBBBKKKKBBYYBBHHHHKKKKKK]],
        [[        BBAABBKKYYYYHHKKYYYYKKKKBBBBBBZZZZZZ]],
        [[    YYBBYYBBKKYYYYYYYYYYKKKKBBKKAAAAZZOOZZZZ]],
        [[    XXXXYYYYBBYYYYYYYYBBBBBBKKKKBBBBAAAAZZZZ]],
        [[    XXXXUUUUYYYYBBYYYYYYBBKKBBZZOOAAZZOOAAAAAA]],
        [[  ZZZZZZXXUUXXXXYYYYYYYYBBAAAAZZOOOOAAOOZZZZAAAA]],
        [[  ZZUUZZXXUUUUXXXXUUXXFFFFFFFFAAAAOOZZAAZZZZ  AA]],
        [[    RRRRUUUUZZZZZZZZXXOOFFFFOOZZOOAAAAAAZZZZAA]],
        [[    CCSSUUUUZZXXXXZZXXOOFFFFOOZZOOOOZZOOAAAA]],
        [[    CCCCUUUUUUUUUURRRROOFFFFOOZZOOOOZZOOZZZZ]],
        [[    CCCCUUUUUUUUSSCCCCEEQQQQOOZZOOOOZZOOZZZZ]],
        [[    CCCCUUGGUUUUCCCCCCEEQQQQOOZZOOOOZZEEZZ]],
        [[    RRRRGGGGUUGGCCCCCCOOOOOOOOZZOOEEZZII]],
        [[      IIRRGGGGGGCCCCCCOOOOOOOOZZEEII]],
        [[            GGRRCCCCCCOOOOEEEEII  II]],
        [[                RRRRRREEEE  IIII]],
        [[                      II]],
        [[]]
      }

      local colors = {
        ["A"] = { fg = mocha.rosewater },
        ["Y"] = { fg = "#FAC87C" },
        ["B"] = { fg = darken("#FAC87C", 5) },
        ["X"] = { fg = darken("#FAC87C", 20) },
        ["U"] = { fg = darken("#FAC87C", 25) },
        ["F"] = { fg = darken("#FAC87C", 35) },
        ["O"] = { fg = darken("#FAC87C", 45) },
        ["K"] = { fg = "#502E2B" },
        ["H"] = { fg = darken("#502E2B", 10) },
        ["Z"] = { fg = mocha.crust },
        ["G"] = { fg = darken("#FAC87C", 25) },
        ["R"] = { fg = "#BF854E" },
        ["Q"] = { fg = darken("#BF854E", 20) },
        ["E"] = { fg = darken("#BF854E", 35) },
        ["I"] = { fg = "#38291B" },
        ["C"] = { fg = mocha.mantle },
        ["S"] = { fg = mocha.subtext1 },
      }

      local header = {}
      for _, line in ipairs(color_map) do
        local header_line = [[]]
        for i = 1, #line do
          if line:sub(i, i) ~= " " then
            header_line = header_line .. "█"
          else
            header_line = header_line .. " "
          end
        end
        table.insert(header, header_line)
      end

      local colorized = colorize(header, color_map, colors)

      dashboard.section.header.val = header
      dashboard.section.header.opts = {
        hl = colorized,
        position = "center",
      }

      dashboard.section.buttons.val = {
        dashboard.button("SPC e e", "  New file", "<Cmd>ene <CR>"),
        dashboard.button("SPC f f", "  Find file"),
        dashboard.button("SPC s", "  Config", "<Cmd>e ~/dotfiles/.config/nvim/init.lua<CR>"),
        dashboard.button("SPC q", "  Quit", "<Cmd>qa<CR>"),
      }


      require("alpha").setup(dashboard.config)
    end,
  },
}

