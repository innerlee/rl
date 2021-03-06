#!/usr/bin/env julia
using ArgParse

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

function iterate(V, lastV, A, γ)
    newV = copy(V)
    for (state, v) in pairs(V)
        isend(state) && continue
        newV[state] = reward(state)
        for (a, p) in greedy_policy(state, lastV, A)
            newV[state] += γ * p * V[next_state(state, a)]
        end
    end
    newV
end

policy_cache = Dict()

# policy: action, probability list
function greedy_policy(state, V, A)
    isend(state) && return Dict()
    values = [V[next_state(state, a)] for a in A]
    actions = A[findall(values .≈ maximum(values))]
    # return
    Dict(a => 1 / length(actions) for a in actions)
end

# reward
function reward(state)
    isend(state) ? 0 : -1
end

## main

function main()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--n", "-n"
            arg_type = Int
            default = 100
            help = "num of inner iteration"
        "--m", "-m"
            arg_type = Int
            default = 10
            help = "num of iteration"
        "--gamma", "-g"
            help = "γ"
            arg_type = Float64
            default = 1.
        "--verbose", "-v"
            help = "verbose"
            action = :store_true
    end
    parsed_args = parse_args(ARGS, s)
    # config
    M = parsed_args["m"]
    N = parsed_args["n"]
    γ = parsed_args["gamma"]
    verbose = parsed_args["verbose"]
    # states
    S = [(i, j) for i in 1:4 for j in 1:4]
    # actions
    A = [:↑, :↓, :←, :→]
    # values
    V = Dict(x => 0. for x in S)
    lastV = copy(V)

    println("---------- init ----------")
    display_value(V)
    for m in 1:M
        println("---------- $m ----------")
        for k in 1:N
            verbose && println("---------- $m-$k")
            V = iterate(V, lastV, A, γ)
            verbose && display_value(V)
        end
        verbose || display_value(V)
        lastV = copy(V)
        V = Dict(x => 0. for x in S)
    end
end

main()
