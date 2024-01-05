
timerStash = {}
transitionStash = {}

function cancelAllTimers()
    local k, v
    for k,v in pairs(timerStash) do
        timer.cancel( v )
        v = nil; k = nil
    end

    timerStash = nil
    timerStash = {}
end

--

function cancelAllTransitions()
    local k, v
    for k,v in pairs(transitionStash) do
        transition.cancel( v )
        v = nil; k = nil
    end

    transitionStash = nil
    transitionStash = {}
end

function pauseAllTimers()
    local k, v
    for k,v in pairs(timerStash) do
        timer.pause( v )
        v = nil; k = nil
    end

    timerStash = nil
    timerStash = {}
end

function resumeAllTimers()
    local k, v
    for k,v in pairs(timerStash) do
        timer.resume( v )
        v = nil; k = nil
    end

    timerStash = nil
    timerStash = {}
end