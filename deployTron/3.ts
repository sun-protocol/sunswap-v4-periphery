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
    args: ['0xD033B0fD1B38D9a8f04a8C2Adc55b91c288930b1'],//
    tags: 'lumi3',
  });
  console.log(res)
};


module.exports.tags = ['lumi3'];
