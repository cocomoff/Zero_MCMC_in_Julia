using Distributions
using Plots
gr()

function compute_hmc(; n_iter=500000, n_tau=10, d_tau=0.1)
    calc_action(x) = 0.5 * x^2

    function calc_hamiltonian(x, p)
        ham = calc_action(x)
        ham += 0.5 * p^2
        ham
    end

    function calc_delh(x)
        delh = x
        delh
    end

    function molecular_dynamics(x)
        p = randn()
        ham_init = calc_hamiltonian(x, p)

        # 1st
        x += p * 0.5 * d_tau

        # 2nd, ..., n_tau-th
        for step in 1:n_tau
            delh = calc_delh(x)
            p += -delh * d_tau
            x += p * d_tau
        end

        # last
        delh = calc_delh(x)
        p += -delh * d_tau
        x += p * 0.5 * d_tau

        ham_fin = calc_hamiltonian(x, p)
        return x, ham_init, ham_fin

    end

    # set the initial configuration
    x = 0
    n_accept = 0
    sum_xx = 0.0

    values = Float64[]

    unif = Uniform(0, 1)

    # main loop
    for iter in 1:n_iter
        backup_x = x
        x, ham_init, ham_fin = molecular_dynamics(x)
        metropolis = rand(unif)
        if exp(ham_init - ham_fin) > metropolis
            n_accept += 1
        else
            x = backup_x
        end

        sum_xx = sum_xx + x * x
        # println("$x $(n_accept/n_iter)")
        push!(values, x)
    end
    values
end


function fig61()
    values = compute_hmc()
    my_gauss(x) = 1.0 ./ sqrt.(2.0 * π) .* exp.(-x .* x ./ 2.0)

    f = plot(size=(600, 400))
    x = -4:0.1:4.0
    plot!(f, x, my_gauss(x), label="exact")
    histogram!(f, collect(values), bins=50, normalize=true, label="HMC")
    savefig(f, "chapter6/fig6.1.png")

end