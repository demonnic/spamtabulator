local spam = Spamtabulator
local stats = spam.stats
stats.lines = stats.lines + 1
spam.resetTimeout()