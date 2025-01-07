return {
  'frankroeder/parrot.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('parrot').setup {
      providers = {
        anthropic = {
          api_key = os.getenv 'ANTHROPIC_API_KEY',
        },
      },
      hooks = {
        CodeConsultant = function(prt, params)
          local chat_prompt = [[
              Your task is to analyze the provided {{filetype}} code and suggest
              improvements to optimize its performance. Identify areas where the
              code can be made more efficient, faster, or less resource-intensive.
              Provide specific suggestions for optimization, along with explanations
              of how these changes can enhance the code's performance. The optimized
              code should maintain the same functionality as the original code while
              demonstrating improved efficiency.

              Here is the code
              ```{{filetype}}
              {{filecontent}}
              ```
            ]]
          prt.ChatNew(params, chat_prompt)
        end,
        CodeConsultantFullContext = function(prt, params)
          local chat_prompt = [[
              Your task is to analyze the provided {{filetype}} code and suggest
              improvements to optimize its performance. Identify areas where the
              code can be made more efficient, faster, or less resource-intensive.
              Provide specific suggestions for optimization, along with explanations
              of how these changes can enhance the code's performance. The optimized
              code should maintain the same functionality as the original code while
              demonstrating improved efficiency.

              ```{{filetype}}
              {{multifilecontent}}
              ```

              Please look at the following section specifically:
              ```{{filetype}}
              {{selection}}
              ```
            ]]
          prt.ChatNew(params, chat_prompt)
        end,
        JSDocWriter = function(prt, params)
          local template = [[
              Your task is to analyze the provided {{filetype}} code and write a JSDoc comment for the function.
              The JSDoc comment should include a description of the function, its parameters, and its return value.
              Include information about the function's behavior, side effects, and any other relevant details.

              Do not explain the code's functionality details in the JSDoc comment.

              Please provide an example of how to call the function and what the expected output would be.

              The path to the file is {{filepath}}.

              Here is all the code in the file:
              ```{{filetype}}
              {{filecontent}}
              ```

              Here is the function you need to write a JSDoc comment for:
              ```{{filetype}}
              {{selection}}
              ```

              Please finish writing the comment for the function as carefully and logically as possible.
              Respond with just the JSDoc comment for the function.
            ]]
          local model_obj = prt.get_model 'command'
          prt.Prompt(params, prt.ui.Target.prepend, model_obj, nil, template)
        end,
        CommitMsg = function(prt, params)
          local futils = require 'parrot.file_utils'
          if futils.find_git_root() == '' then
            prt.logger.warning 'Not in a git repository'
            return
          else
            local template = [[
            I want you to act as a commit message generator. I will provide you
            with information about the task and the prefix for the task code, and
            I would like you to generate an appropriate commit message using the
            conventional commit format. Do not write any explanations or other
            words, just reply with the commit message.
            Start with a short headline as summary but then list the individual
            changes in more detail.

            Here are the changes that should be considered by this message:
            ]] .. vim.fn.system 'git diff --no-color --no-ext-diff --staged'
            local model_obj = prt.get_model 'command'
            prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
          end
        end,
        UnitTests = function(prt, params)
          local template = [[
          I have the following code from {{filename}}:

          ```{{filetype}}
          {{selection}}
          ```

          Please respond by writing table driven unit tests for the code above.
          ]]
          local model_obj = prt.get_model 'command'
          prt.logger.info('Creating unit tests for selection with model: ' .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
        end,
        Optimize = function(prt, params)
          local template = [[
          You are an expert in {{filetype}}.
          Your task is to analyze the provided {{filetype}} code snippet and
          suggest improvements to optimize its performance. Identify areas
          where the code can be made more efficient, faster, or less
          resource-intensive. Provide specific suggestions for optimization,
          along with explanations of how these changes can enhance the code's
          performance. The optimized code should maintain the same functionality
          as the original code while demonstrating improved efficiency.

          ```{{filetype}}
          {{selection}}
          ```

          Optimized code:
          ]]
          local model_obj = prt.get_model 'command'
          prt.logger.info('Optimizing selection with model: ' .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
        end,
        FixBugs = function(prt, params)
          local template = [[
          You are an expert in {{filetype}}.
          Fix bugs in the below code from {{filename}} carefully and logically:
          Your task is to analyze the provided {{filetype}} code snippet, identify
          any bugs or errors present, and provide a corrected version of the code
          that resolves these issues. Explain the problems you found in the
          original code and how your fixes address them. The corrected code should
          be functional, efficient, and adhere to best practices in
          {{filetype}} programming.

          ```{{filetype}}
          {{selection}}
          ```

          Fixed code:
          ]]
          local model_obj = prt.get_model 'command'
          prt.logger.info('Fixing bugs in selection with model: ' .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
        end,
        Explain = function(prt, params)
          local template = [[
          Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
          Break down the code's functionality, purpose, and key components.
          The goal is to help the reader understand what the code does and how it works.

          ```{{filetype}}
          {{selection}}
          ```

          Use the markdown format with codeblocks and inline code.
          Explanation of the code above:
          ]]
          prt.ChatNew(params, template)
        end,
        CompleteFullContext = function(prt, params)
          local template = [[
          I have the following code from {{filename}}:

          ```{{filetype}}
          {filecontent}}
          ```

          Please look at the following section specifically:
          ```{{filetype}}
          {{selection}}
          ```

          Please finish the code above carefully and logically.
          Respond just with the snippet of code that should be inserted.
          ]]
          local model_obj = prt.get_model 'command'
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
        CompleteMultiContext = function(prt, params)
          local template = [[
          I have the following code from {{filename}} and other related files:

          ```{{filetype}}
          {{multifilecontent}}
          ```

          Please look at the following section specifically:
          ```{{filetype}}
          {{selection}}
          ```

          Please finish the code above carefully and logically.
          Respond just with the snippet of code that should be inserted.
          ]]
          local model_obj = prt.get_model 'command'
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
      },
    }
  end,
}
