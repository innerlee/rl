
# stop condition
isend(s) = s in [(1, 1), (4, 4)]

# transition
function next_state(current_state, action)
    i, j = current_state
    if action == :↑
        j = max(1, j - 1)
    elseif action == :↓
        j = min(4, j + 1)
    elseif action == :←
        i = max(1, i - 1)
    elseif action == :→
        i = min(4, i + 1)
    else
        error("action not valid")
    end
    (i, j)
end

# display values and greedy policy
function display_value(V)
    Vmat= zeros(4, 4)
    for ((i, j), v) in pairs(V)
        Vmat[i, j] = round(v, digits=1)
    end
    println(join(split(repr("text/plain", Vmat), "\n")[2:end], "\n"))
end

function iterate(V, A, γ)
    newV = copy(V)
    for (state, v) in pairs(V)
        isend(state) && continue
        newV[state] = reward(state)
        for (a, p) in policy(state, A)
            newV[state] += γ * p * V[next_state(state, a)]
        end
    end
    newV
end

# policy: action, probability list
function policy(state, A)
    isend(state) && return Dict()
    Dict(a => 1 / length(A) for a in A)
end

# reward
function reward(state)
    isend(state) ? 0 : -1
end

## main

function main()
    # config
    N = 10
    γ = 1
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
        V = iterate(V, A, γ)
        display_value(V)
    end

end

main()
