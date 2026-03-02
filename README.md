# SunSwap V4 Periphery

SunSwap V4 Periphery is the periphery contracts repository of the SunSwap V4 protocol. It is built with Hardhat and Foundry, and supports development, testing, and deployment on Tron networks.

## Deployments

| contract             | chain | address                            |
| :------------------- | :---- | :--------------------------------- |
| CLPositionDescriptor | TRON  | TVx4x5TBTD5tq8Qz8ssF4jMsFu5c65i3Br |
|                      | NILE  | TWFWkGYT4MAf2kySVuEkJVyfz4121pPGhf |
| CLPositionManager    | TRON  | TC8xQzPHfn5KceZV6s6GmZkBCFWWUoPXs1 |
|                      | NILE  | TMTQ1BYo15aGgZXHcsBWXyae8bVaAdgfLP |
| CLQuoter             | TRON  | TSupQTJWWoVpUqA7KGVYb8dB97n3civwiJ |
|                      | NILE  | TWbsXKMjoDPjW4kjqv4qs5gbesnJ8wKref |
| TickLens             | TRON  | TTuDCMoRaAKGL4V1gmJpmRKpDQz2ZCRQZL |
|                      | NILE  | TFzuLipxEyB3McrYbvmtSvdpTo3A3RQPGv |
| CLLPFeesHelper       | TRON  | TYKPrQ45J7w9E73JaTe9VWR7yAut8nkbgf |
|                      | NILE  | TFzuLipxEyB3McrYbvmtSvdpTo3A3RQPGv |

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
