# Zero MCMC in Julia

- Julia port for ゼロからできるMCMC マルコフ連鎖モンテカルロ法の実践的入門

## Contents

- Chapter 2
    - [x] pi_MC.jl モンテカルロ法(円)でπ/4を推定
    - [x] pi_MC_integral.jl モンテカルロ法(積分)でπ/4を推定
    - [x] three_sphere.jl モンテカルロ法(球体)で4/3πを推定
- Chapter 4
    - [ ] Gaussian_Metropolis.jl 
        - [x] 図4.1を再現 (メトロポリス法で標準正規分布をサンプル)
        - [x] 図4.2を再現 (平均/分散のサンプル計算)
        - [x] 図4.3を再現 (分布のずれ)
        - [x] 図4.4/4.5を再現 (初期値依存性，局所的な依存)
        - [ ] 図4.6 ジャックナイフ誤差
        - [ ] 図4.7 w=50の場合の書くグループの平均値
        - [x] 図4.8 ステップ幅の調整
        - [x] 図4.9 重ねあった分布のサンプル
        - [ ] 図4.10 重ねった分布その2 (未動作)
- Chapter 5
    - [x] Gaussian_Metropolis_2var.jl
        - [x] 図5.1
        - [x] 図5.3 (physics) 図5.4 (baseball) (N少なめ)
        - [ ] 図5.5 reweight 未実装
    - [x] graph.jl
        - [x] 図5.2
    - 
- Chapter 6
    - [ ] Gaussian_HMC.jl
- Chapter 7以降 まだ