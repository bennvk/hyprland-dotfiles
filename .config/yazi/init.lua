-- Plugins

require("no-status"):setup()
require("git"):setup { order = 1500 }

-- Linemode

function Linemode:size_and_mtime()
    local time = math.floor(self._file.cha.mtime or 0)
    if time == 0 then
        time = ""
    else
        local current_year = os.date("%Y")
        local file_year = os.date("%Y", time)
        if file_year == current_year then
            time = os.date("%d/%m", time)
        else
            time = os.date("%d/%m/%Y", time)
        end
    end

    local size = self._file:size()
    local readable_size
    if size then
        local units = {"B", "Ko", "Mo", "Go", "To"}
        local i = 1
        local s = size * 1.0
        while s >= 1024 and i < #units do
            s = s / 1024
            i = i + 1
        end
        readable_size = string.format("%.2f %s |", s, units[i])
    else
        readable_size = ""
    end

    return string.format("%s %s", readable_size, time)
end
