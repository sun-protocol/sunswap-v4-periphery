module.exports = async ({
  getNamedAccounts,
  deployments,
  getChainId,
  getUnnamedAccounts,
}) => {
  const {deploy} = deployments;
  const {deployer} = await getNamedAccounts();

  // the following will only deploy "GenericMetaTxProcessor" if the contract was never deployed or if the code changed since last deployment
  // IVault _vault,
  // ICLPoolManager _clPoolManager,
  // IAllowanceTransfer _permit2,
  // uint256 _unsubscribeGasLimit,
  // ICLPositionDescriptor _tokenDescriptor,
  // IWETH9 _weth9
  const res = await deploy('CLPositionManager', {
    from: deployer,
    gasLimit: 4000000,
    args: ['0x60FD86BC6BA0A2131CC92DC9B637BEC98159BAE8','0x60FD86BC6BA0A2131CC92DC9B637BEC98159BAE8','0xF62F506D1FAA02E2354A9886B4A200496EE96F4B',0,'0x5A15F13419F683D5B56A140732E758B4892D9597',
    '0xFB3B3134F13CCD2C81F4012E53024E8135D58FEE'
    ],//
    tags: 'lumi2',
  });
  console.log(res)
};


module.exports.tags = ['lumi2'];
