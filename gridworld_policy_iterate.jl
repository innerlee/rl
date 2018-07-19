
# transition
function next_state(current_state, action)
    i, j = current_state
    if action == ↑
        j = max(1, j - 1)
    elseif action == ↓
        j = min(4, j + 1)
    elseif action == ←
        i = max(1, i - 1)
    elseif action == →
        i = min(4, i + 1)
    else
        error("action not valid")
    end
end

# display values and greedy policy
function display_value(V)
    Vmat= zeros(4, 4)
    for ((i, j), v) in pairs(V)
        Vmat[i, j] = v
    end
    println(join(split(repr("text/plain", Vmat), "\n")[2:end], "\n"))
end

function iterate(V)
    newV = copy(V)
    for ((i, j), v) in pairs(V)
        newV[(i, j)] = v
    end
    newV
end

## main

function main()
    # config
    N = 10
    # states
    S = [(i, j) for i in 1:4 for j in 1:4]
    # actions
    ↑, ↓, ←, → = :↑, :↓, :←, :→
    A = [↑, ↓, ←, →]
    # values
    V = Dict(x => 0. for x in S)

    println("---------- init ----------")
    display_value(V)
    for k in 1:N
        println("---------- $k ----------")
        V = iterate(V)
        display_value(V)
    end

end

main()
