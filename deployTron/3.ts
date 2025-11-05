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
  const res = await deploy('CLQuoter', {
    from: deployer,
    gasLimit: 4000000,
    args: ['0x60FD86BC6BA0A2131CC92DC9B637BEC98159BAE8'],//
    tags: 'lumi3',
  });
  console.log(res)
};


module.exports.tags = ['lumi3'];
