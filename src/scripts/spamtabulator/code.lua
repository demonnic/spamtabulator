Spamtabulator = Spamtabulator or {enabled = false, stats = {lines = 0}}
local spam = Spamtabulator
local watch = "spamtabulatorStopWatch"
local dir = getMudletHomeDir() .. "/spamstats"
function spam.start()
  if spam.enabled then
    return
  end
  spam.enabled = true
  spam.stats = {lines = 0}
  enableTrigger("spamtabulator")
  createStopWatch(watch)
  resetStopWatch(watch)
  startStopWatch(watch)
  spam.resetTimeout()
end

function spam.stop()
  if not spam.enabled then
    return
  end
  spam.enabled = false
  local timeSinceLine = 30 - (remainingTime(spam.timeoutID) or 0)
  killTimer(spam.timeoutID)
  local totalSeconds = stopStopWatch(watch) - timeSinceLine
  disableTrigger("spamtabulator")
  if not totalSeconds then
    return
  end
  local stats = spam.stats
  spam.stats.totalSeconds = totalSeconds
  spam.stats.linesPerSecond = spam.stats.lines / totalSeconds
  spam.stats.timePerLine = totalSeconds / spam.stats.lines
  spam.upload()
  --spam.write()
end

function spam.toggle()
  if spam.enabled then
    spam.stop()
    return
  end
  spam.start()
end

function spam.resetTimeout()
  if spam.timeoutID then
    killTimer(spam.timeoutID)
  end
  spam.timeoutID = tempTimer(30, spam.stop)
end

local function secho(msg)
  cecho("<orange>(<green>spamtabulator<orange>)<r> " .. msg .. "\n")
end
function spam.upload()
  local endpoint = "http://hollerandhoot.com:9090/reportSpam"
  local body = yajl.to_string(spam.stats)
  local header = {["Content-Type"] = "application/json"}
  local handler = function(event, err, url)
    local isError = event:find("Error")
    if isError then
      url = url:gsub("http//", "")
      if url ~= endpoint then
        return true
      end
      secho("Error uploading results: " .. err)
    else
      if err ~= endpoint then
        return true
      end
      secho("Results uploaded successfully. Thank you very much.")
    end
    stopNamedEventHandler("spamtabulator", "postError")
    stopNamedEventHandler("spamtabulator", "postDone")
  end
  registerNamedEventHandler("spamtabulator", "postError", "sysPostHttpError", handler, true)
  registerNamedEventHandler("spamtabulator", "postDone", "sysPostHttpDone", handler, true)
  postHTTP(body, endpoint, header)
end

function spam.write()
  local ttbl = getTime()
  if not ttbl then
    return
  end
  local year = ttbl.year
  local month = string.format("%02d", ttbl.month)
  local day = string.format("%02d", ttbl.day)
  local hour = string.format("%02d", ttbl.hour)
  local min = string.format("%02d", ttbl.min)
  local sec = string.format("%02d", ttbl.sec)
  local file = f "{dir}/{year}-{month}-{day}-{hour}{min}{sec}.lua"
  if not io.exists(dir) then
    lfs.mkdir(dir)
  end
  table.save(file, spam.stats)
end

if not spam.enabled then
  disableTrigger("spamtabulator")
end