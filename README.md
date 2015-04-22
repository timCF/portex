Portex
======

Example of usage

```
Interactive Elixir (1.0.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Portex.open :node, "node -i"
:ok
iex(2)>
16:02:36.096 [error] Elixir.Portex.Worker : unexpected data in definfo {#Port<0.4985>, {:data, "> "}}

nil
iex(3)> Portex.exec(:node, "123\nconsole.log(123);\n")
["> ", "undefined\n", "123\n", "> ", "123\n"]
iex(4)>
```