local arg = matches[2] and matches[2]:trim() or false
local spam = Spamtabulator
if not arg then
  spam.toggle()
elseif arg == "update" then
  uninstallPackage("spamtabulator")
  installPackage("https://github.com/demonnic/spamtabulator/releases/latest/download/spamtabulator.mpackage")
else
  spam[arg]()
end