# SunSwap V4 Periphery

SunSwap V4 Periphery is the periphery contracts repository of the SunSwap V4 protocol. It is built with Hardhat and Foundry, and supports development, testing, and deployment on Tron networks.

SunSwap V4 Periphery provides the higher-level contracts, routers, and utilities that simplify interaction with the SunSwap V4 Core.  
While the Core contracts implement the fundamental AMM logic and state management, the Periphery contracts are designed to make these operations more accessible for developers, integrators, and end users.

Key components include:

- **SwapRouter**: handles single-hop and multi-hop swaps across pools.
- **Position Manager**: manages liquidity positions, enabling minting, burning, and fee collection.
- **Helper libraries**: provide utilities for approvals, pool interactions, and transaction execution.

Together, the Periphery contracts act as the user-facing layer of SunSwap V4, bridging low-level protocol mechanics with wallets, dApps, and DeFi platforms. This design ensures that developers can integrate advanced AMM features without dealing directly with the complexity of Core contracts.

---

## Deployments

| contract             | chain        | address                            |
| :------------------- | :----------- | :--------------------------------- |
| CLPositionDescriptor | TRON Mainnet | TVx4x5TBTD5tq8Qz8ssF4jMsFu5c65i3Br |
|                      | NILE Testnet | TWFWkGYT4MAf2kySVuEkJVyfz4121pPGhf |
| CLPositionManager    | TRON Mainnet | TC8xQzPHfn5KceZV6s6GmZkBCFWWUoPXs1 |
|                      | NILE Testnet | TMTQ1BYo15aGgZXHcsBWXyae8bVaAdgfLP |
| CLQuoter             | TRON Mainnet | TSupQTJWWoVpUqA7KGVYb8dB97n3civwiJ |
|                      | NILE Testnet | TWbsXKMjoDPjW4kjqv4qs5gbesnJ8wKref |
| TickLens             | TRON Mainnet | TTuDCMoRaAKGL4V1gmJpmRKpDQz2ZCRQZL |
|                      | NILE Testnet | TFzuLipxEyB3McrYbvmtSvdpTo3A3RQPGv |
| CLLPFeesHelper       | TRON Mainnet | TYKPrQ45J7w9E73JaTe9VWR7yAut8nkbgf |
|                      | NILE Testnet | TFzuLipxEyB3McrYbvmtSvdpTo3A3RQPGv |


---

## Compile, Test and Deploy

### Installation

```bash
pnpm install
```

### Compile

```bash
forge compile
```

### Tests

```bash
forge test
```

### Deploy

1. Set PRIVATE_KEY

```bash
export PRIVATE_KEY='Your_Private_Key'
```

2. Adapt the scripts under `deploy/` or `deployTron/` as needed to deploy the contracts, then run:

```bash
npx hardhat deploy --network <network> --tags <tag>
```

or use npm scripts:

```bash
npm run deploy-tron   # Tron network
npm run deploy        # other EVM-compatible networks
```

After deployment, you can check deployed contract info at:

```text
deployments/<network>/<contractName>.json
```

---

## Community & Support

If you have questions about this project, find bugs, or would like to contribute, you can reach the team and community via:

- [Telegram](https://t.me/SunIO_Defi)
- [Twitter](https://twitter.com/defi_sunio)

Please follow official announcements from these channels for the latest information on deployments, upgrades, and security notices.
## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the GitLab-first development model,
GitHub release synchronization, review requirements, and validation guidance.
