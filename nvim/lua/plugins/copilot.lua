return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = '<C-l>',
          accept_word = false,
          accept_line = false,
          next = '<C-j>',
          prev = '<C-k>',
          dismiss = '<C-]>',
        },
      },
    }
  end,
}

