local chain = require('chainsaw')

chain.setup({
    marker = "[dupa]",
    logStatements = {
        variableLog = {
            go = 'fmt.Println("%s %s: ",%s)',
        },
        objectLog = {
            go = '/*%s*/b,_:=json.MarshalIndent(%s,""," ");fmt.Println(string(b))//[dupa]',
        },
    }
})


vim.keymap.set("n", "<leader>ol", chain.objectLog)
vim.keymap.set("n", "<leader>vl", chain.variableLog)
vim.keymap.set("n", "<leader>rl", chain.removeLogs)
