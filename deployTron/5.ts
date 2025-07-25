module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId,
  getUnnamedAccounts,
}) => {
  const {deploy} = deployments;
  const {deployer} = await getNamedAccounts();

  
    // address _factoryV3,
    // address _factoryV2,
    // address _factoryStable,
    // address _WETH9,
    // ICLQuoter _clQuoter
    // permit2: "0xF62F506D1FAA02E2354A9886B4A200496EE96F4B",
    // weth9: "0xFB3B3134F13CCD2C81F4012E53024E8135D58FEE",
    // v2Factory: "0x55F7D5D874A73F21C0851C62D374307985F440FC",
    // v3Factory: "0xCAC0EE410E19A12CCE8805D5374BB60200FADD03",
    // v3Deployer: "0x1234567890abcdef1234567890abcdef12345678", 
    // v2InitCodeHash: "0x9dd9bfc2f6c1103a6c01d9c6a4044e4b8a9361f92df2728cdc3729922d56748e",
    // v3InitCodeHash: "0xbdafe9a36668104a2d371dedf31aac9583722f1b2c2fe98dde229f50a1e81689",
    // stableFactory: "0xabcdefabcdefabcdefabcdefabcdefabcdefabcd",
    // stableInfo: "0x1234567890abcdef1234567890abcdef12345678",
    // infiVault: "0xD033B0fD1B38D9a8f04a8C2Adc55b91c288930b1",
    // infiClPoolManager: "0xD033B0fD1B38D9a8f04a8C2Adc55b91c288930b1",
    // v3NFTPositionManager: "0x937A4ADE5E502DAAD2F640B58E0346FF5A13A01F",
    // infiClPositionManager: "0xCF386E76CC4B99F164D4603C062EFE05A98D2E24",
  const res = await deploy('MixedQuoter', {
    from: deployer,
    gasLimit: 400000000,
    args: [
      '0xCAC0EE410E19A12CCE8805D5374BB60200FADD03', //v3factory
      '0x55F7D5D874A73F21C0851C62D374307985F440FC', //v2factory
      '0x1234567890abcdef1234567890abcdef12345678', //_factoryStable
      '0xFB3B3134F13CCD2C81F4012E53024E8135D58FEE', //weth9
      '0xD3ACB834232A00419268BB093419D584B546C575' //clQuoter
    ],//
    tags: 'lumi5',
  });
  console.log(res)
};


module.exports.tags = ['lumi5'];
