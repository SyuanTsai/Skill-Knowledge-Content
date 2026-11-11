# SPDX-FileCopyrightText: 2026 SyuanTsai
# SPDX-License-Identifier: Apache-2.0
#requires -Version 7.0

Set-StrictMode -Version Latest

$script:KnowledgeContentPreparedAuthorityRepository = 'https://github.com/SyuanTsai/SyuanTsai-AI-Instructions.git'
$script:KnowledgeContentPreparedAuthorityCommit = '6cee5b8e43fe4e327fedc788865f931c561d6e89'
$script:KnowledgeContentPreparedAuthorityArchiveSha256 = '336290db31dde3d04fe89f11d90e517f88e8140b1b235b72fe01f7ed12345cd2'
$script:KnowledgeContentPreparedAuthorityFiles = [ordered]@{
    'docs/standards/README.md' = '69ddc46b4ca4aca06001aaa0fb5b078ef38168f67c21552f3b075548ea707441'
    'docs/standards/managed-skill-lifecycle.md' = '4e3f8595072d663f51d18aa28f42293fda5456362b49c0ea3f0157ae3dcf56dd'
    'docs/standards/schemas/managed-skill-lifecycle-v1.schema.json' = '9a7f4c02588d2b88194e953a41766a72a9426fa89d4c3781c5750dcc22d35863'
    'docs/standards/schemas/openai-agent-metadata.schema.json' = '23c1aaee28a54fea1946a61d6122a2097906ffa5bdd66c8014fc6b1625c9062a'
    'docs/standards/schemas/source-inventory-v2.schema.json' = '084550944b4141ab5535f58fb6e99730a5c34b56103f6b59fd5a352679caa98e'
    'docs/standards/schemas/validation-security-gate-v1.schema.json' = 'b924b28a791f4d6eedcc0aa1c01fb62687ec863c0c17048093bfdd99aaa55b74'
    'docs/standards/skill-repository-review-matrix.md' = '360346bee26f24c2dad27ea0827415150b82b555332c0d7f3d4e27bb56cf3a49'
    'docs/standards/skill-repository-standard.md' = '24a932ff333bc74884fee8e1e784da2a7cd832373e8e0659469995be2659f1a0'
    'docs/standards/upstream-interoperability.md' = '8e48cc4831d151ffa4665433d79ad88e8871cb1d694861908dd0206406dcefe5'
    'docs/standards/validation-security-gate.json' = '1ab4c1208885a3aeb74654d8133426367134446e2b7519f06e63de3a53b16067'
    'docs/standards/validation-toolchain.json' = '1dddbf4c5736e22e56f6ecb298542f41d39e116ab00ca24ad18beb7a3eab40ed'
    'scripts/Invoke-StandardAuthorityGate.ps1' = '72dd032005a6d810f5de4ce492f964585678087a54f921e4fcb90cf5875effe1'
    'scripts/Resolve-PythonWheelClosure.py' = 'a17989f409f8394af2c851db4d33e9a5b003d0dc17a9689de8de0542c0862ca8'
    'scripts/Resolve-StandardValidationTool.ps1' = 'e51c78847aa706dd4bed92fa1e91e1c992e0b1e8d938aaa605c4c7389b66b8f5'
    'docs/standards/schemas/standard-validation-adapter-v1.schema.json' = '11aa88fc25716d748bd4f514f1a44f02390ad1745dd5a5c5beee07f642fd5639'
    'docs/standards/schemas/standard-validation-evidence-v1.schema.json' = '2e8cad8361447baba45b16c47ef685ad2de4a7f27848dd8ddd3fd83e500f23bf'
    'docs/standards/standard-validation-contract-v1.json' = 'f39b2e40c5e9f5eed0abc0d033deea751c8ee978499a86dc4fde3beb65c65242'
    'docs/standards/pr12-source-merge-adoption.json' = '4c5262f2a11d228195230c15fa4faaf9614af6b59f110e5d9c08f242ce809175'
    'docs/standards/trust-anchors/human-approval-public-key.xml' = '1e46153b72d02f3ce2fb26becd449df4f1590d8e5cb441b1954006a5602bbd9b'
    'docs/standards/trust-anchors/trusted-supervisor-public-key.xml' = '4d550851f43405920156f40c9fc648d99a69dd73efc200f6968d8a837e7fbf27'
    'scripts/Invoke-StandardValidation.ps1' = '106e75f8882e8a3121c09605c986afaac97c33db94d64b145297fc3370ac6bc5'
    'docs/standards/schemas/standard-semantic-consent-evidence-v2.schema.json' = '109091979d0a47e2035d3d8b20963fcdb85680e5da737bf1f27121608115d430'
    'scripts/StandardSemanticBridge.psm1' = '6de6746465fce2e3a9636207b7c3a6298c405fdd2d7e8544cf0eada8922767ea'
    'docs/standards/schemas/upstream-adapter-v1.schema.json' = '3cff6246463188a91cc54c6a46315a949314767a759c6214e5b28e4db95ac8d7'
    'docs/standards/upstream-adapter.json' = 'c4f5133b24841bb9c66182dc3d5a027596f864ec28e410d47249a67b3b97ad31'
    'scripts/Validate-UpstreamAdapter.ps1' = '3b6e6474690b1ae9f9486544b68f50ca29b96f5dbe6aa8d6c6cd8570afad500b'
    'docs/standards/standard-core-validation-v2.json' = 'dd3c3d1bb83a439895ed35a949ff376b9d59d25e69063c86714eb42edaad84df'
    'docs/standards/schemas/standard-core-adapter-v2.schema.json' = '7399980e8765528b759a3734a133447eb9581ac24a9c4780dc8faadd6af0c1c5'
    'docs/standards/schemas/standard-core-evidence-v2.schema.json' = '7c083b9603b75518220e7e70e5704728a7e3dee0d5b5cf09dc9c755f49d64153'
    'docs/standards/third-party-raw-skill-sources.md' = '18649fd56eada4a94a5d47de778669b0ebcecfb85b84f5c581d283b21979f7ac'
    'docs/standards/schemas/third-party-raw-skill-source-v1.schema.json' = '9d8585d95c606486f947a3f89e39341af840335376e86910eb7f4ed25bdc16ed'
    'docs/standards/examples/third-party-raw-skill-source-v1.json' = 'decbf276cbeea33c60d8b36b7b16838babe951cd84d13ae4a8a7a8261dc6d9c8'
    'docs/standards/static-parser-host-ownership.json' = '994acd989327d094d22ce2c68ca20eceec609f4e494f4e5d252cfcdef742de2c'
    'docs/standards/schemas/static-parser-host-ownership-v1.schema.json' = '7f8d766b7e36052b68d924c5886157734e9969c198b03b2dadf3a63bebc95bb3'
    'docs/standards/schemas/static-parser-profile-execution-v1.schema.json' = '6353bcd130093ffcdb7b6f979f8d115c02a31efae41e63f8a956e82935ab8887'
    'scripts/platform-runtime.psd1' = 'df700c6c1c3c8dd2e1b24e617fabd8f4dac25e44c06d26875083ce3ce1746a91'
    'scripts/platform-runtime.psm1' = '3f0f09fede0ead288289058251264bec672cb3948ae7d9b0cd47eba97a494a01'
    'scripts/installer-safe-mutation.psm1' = 'ac1e73ffb1b8ea1b95fdc3a177449442281d3d485f62ec42e464f6f5f38ba359'
    'scripts/platform/Linux.psm1' = '82e7a6412abd51da98f7eb1777518dc9714dcaa3a72954af8a8ba5e959d3d879'
    'scripts/platform/MacOS.psm1' = '8764dfdec8e65f452a1cb4edd9dcaa221d7ad901a6eab75427b585541343b770'
    'scripts/platform/OwnedProcess.cs' = '097061ad5902f896ff74b3f60b0ecaf63f3d58f357aed8fdbf80a8586564de58'
    'scripts/platform/PlatformNative.cs' = 'e6a19e6793728a5bb72628faa3926abb6d58ffbee7847a07b53349ee18e6fbf3'
    'scripts/platform/RuntimePreparation.psm1' = 'dc254c04e7e2caf280726e66f67434776bc7df12a210a38c80596e41344fd077'
    'scripts/platform/Unix.psm1' = '6199e45d01293d970f33195368cdef0630b1392a4eb00a289ef85c10eda1eef0'
    'scripts/platform/UnixNative.cs' = 'dd95835adcc4c19509fab6df017ad8f9db1aa7d61468c3dc687547cd2cb11b79'
    'scripts/platform/UnixProcess.cs' = '125d2b3eecdad6a6c201d5f5d61a6efd0ad55ba93822c7b83a679a5397005db1'
    'scripts/platform/Windows.psm1' = 'bb916f529ebf99c7893f541749e91ae7b4b22bd66f2c2f2efce91a8b4977d7cd'
    'scripts/platform/WindowsNative.cs' = '3c4eca15ee608d72b3985db1ab34ad9558243385b2cbe84d909b8cd219482181'
    'scripts/platform/WindowsProcess.cs' = '7b8a0cddd3b9809b861801fe1d6a618684e2ca6fa13f9334825c5c9da5b2d8d6'
}

$script:KnowledgeContentActiveAuthorityCommit = 'ead467c3488c103546f316d137196b447a1ff58a'
$script:KnowledgeContentActiveAuthorityArchiveSha256 = 'ab304bc6caabe4bb9b605f403c852650e19e25f72999010db61bbad695e1c60b'
$script:KnowledgeContentActiveAuthorityFiles = [ordered]@{
    'docs/standards/README.md' = '8aef64a9e69848c82d0ceba43f14c2876e3816cbc4761bac26a35e6f62aaf884'
    'docs/standards/managed-skill-lifecycle.md' = '4e3f8595072d663f51d18aa28f42293fda5456362b49c0ea3f0157ae3dcf56dd'
    'docs/standards/schemas/managed-skill-lifecycle-v1.schema.json' = '9a7f4c02588d2b88194e953a41766a72a9426fa89d4c3781c5750dcc22d35863'
    'docs/standards/schemas/openai-agent-metadata.schema.json' = '23c1aaee28a54fea1946a61d6122a2097906ffa5bdd66c8014fc6b1625c9062a'
    'docs/standards/schemas/source-inventory-v2.schema.json' = '084550944b4141ab5535f58fb6e99730a5c34b56103f6b59fd5a352679caa98e'
    'docs/standards/schemas/validation-security-gate-v1.schema.json' = 'b924b28a791f4d6eedcc0aa1c01fb62687ec863c0c17048093bfdd99aaa55b74'
    'docs/standards/skill-repository-review-matrix.md' = 'db0f898b2e59e0600abe3ec93684e561db339c82547d9035b18285f0285672ab'
    'docs/standards/skill-repository-standard.md' = '1815569ebfc727bdc8ce1d906ecd63769fb2cf323d526074aa687ffe6b12b2c3'
    'docs/standards/upstream-interoperability.md' = '8e48cc4831d151ffa4665433d79ad88e8871cb1d694861908dd0206406dcefe5'
    'docs/standards/validation-security-gate.json' = '1ab4c1208885a3aeb74654d8133426367134446e2b7519f06e63de3a53b16067'
    'docs/standards/validation-toolchain.json' = '001054854960563201d969a826db990f01ab93a2e87120ccc5ee42be8f8417d7'
    'scripts/Invoke-StandardAuthorityGate.ps1' = 'b4972681e79f788485e3925b737a7b0faac38a63c617450472758f2cc33798ef'
    'scripts/Resolve-PythonWheelClosure.py' = '4d6325bc7d425e6fe2ef474d7f78fe8966b44ec5e1acee86f2417dc740d1fcea'
    'scripts/Resolve-StandardValidationTool.ps1' = 'c0d68b227fc04e19d710a89c4559fe45e0cc979eead846006261dc2dc5bfa14f'
    'docs/standards/schemas/standard-validation-adapter-v1.schema.json' = '11aa88fc25716d748bd4f514f1a44f02390ad1745dd5a5c5beee07f642fd5639'
    'docs/standards/schemas/standard-validation-evidence-v1.schema.json' = 'e177a6832d055b51a440615fec65d01941b1b0c32bf468b962c8eb79750db924'
    'docs/standards/standard-validation-contract-v1.json' = '2fa394ee48f940cdc2272c64199b90d95dea3665e1496df49cd0bd695cbdbe15'
    'docs/standards/pr12-source-merge-adoption.json' = '4c5262f2a11d228195230c15fa4faaf9614af6b59f110e5d9c08f242ce809175'
    'docs/standards/trust-anchors/human-approval-public-key.xml' = '1e46153b72d02f3ce2fb26becd449df4f1590d8e5cb441b1954006a5602bbd9b'
    'docs/standards/trust-anchors/trusted-supervisor-public-key.xml' = '4d550851f43405920156f40c9fc648d99a69dd73efc200f6968d8a837e7fbf27'
    'scripts/Invoke-StandardValidation.ps1' = 'f203c59a0440e9eddf076ba5d68acd1368facc222789905586eeeb2a87b71c1d'
    'docs/standards/schemas/standard-semantic-consent-evidence-v2.schema.json' = '109091979d0a47e2035d3d8b20963fcdb85680e5da737bf1f27121608115d430'
    'scripts/StandardSemanticBridge.psm1' = '92595bdbb98ae77bdb2cc4dd7605ecc29f54e0a6746c9ee7d7636655f65665ef'
    'docs/standards/schemas/upstream-adapter-v1.schema.json' = '3cff6246463188a91cc54c6a46315a949314767a759c6214e5b28e4db95ac8d7'
    'docs/standards/upstream-adapter.json' = 'c4f5133b24841bb9c66182dc3d5a027596f864ec28e410d47249a67b3b97ad31'
    'scripts/Validate-UpstreamAdapter.ps1' = '3b6e6474690b1ae9f9486544b68f50ca29b96f5dbe6aa8d6c6cd8570afad500b'
    'docs/standards/standard-core-validation-v2.json' = 'dd3c3d1bb83a439895ed35a949ff376b9d59d25e69063c86714eb42edaad84df'
    'docs/standards/schemas/standard-core-adapter-v2.schema.json' = '7399980e8765528b759a3734a133447eb9581ac24a9c4780dc8faadd6af0c1c5'
    'docs/standards/schemas/standard-core-evidence-v2.schema.json' = '7c083b9603b75518220e7e70e5704728a7e3dee0d5b5cf09dc9c755f49d64153'
    'docs/standards/third-party-raw-skill-sources.md' = '18649fd56eada4a94a5d47de778669b0ebcecfb85b84f5c581d283b21979f7ac'
    'docs/standards/schemas/third-party-raw-skill-source-v1.schema.json' = '9d8585d95c606486f947a3f89e39341af840335376e86910eb7f4ed25bdc16ed'
    'docs/standards/examples/third-party-raw-skill-source-v1.json' = 'decbf276cbeea33c60d8b36b7b16838babe951cd84d13ae4a8a7a8261dc6d9c8'
    'docs/standards/skillspector-approved-sources.json' = 'baaaf2a66e98f2c28a48fddd04051f09cf5498ef6c7978cbf45f5d415b69a330'
    'docs/standards/schemas/skillspector-approved-sources-v1.schema.json' = '20fa8516c9dcb7c9ae15f4682092dc583411db3149fac2641fef7b5182c3d12b'
    'docs/standards/static-parser-host-ownership.json' = '994acd989327d094d22ce2c68ca20eceec609f4e494f4e5d252cfcdef742de2c'
    'scripts/platform-runtime.psd1' = '7f112390d2995a105b9e9a916876df1779485dec6df21d7516243e2dcd1c4dca'
    'scripts/platform-runtime.psm1' = 'ad051b2794ce4dc10108404201735d02f7b032ed0e633c5f22f73c884fb10370'
    'scripts/installer-safe-mutation.psm1' = 'dc031edcc2f48968df83cd68ad52eacb7f7b05d3ca6a0cc622658cf6151c8293'
    'scripts/WindowsDacl.psm1' = 'ffa1f85d94bb6bce9bf8353f8c7733bdbe59880a3d0d075191938cc28aebb5f6'
    'scripts/platform/PlatformNative.cs' = 'f9da23bf3e6e3c8960b26d534e14873f6b4fc98b3d13f5b6cdfdd5f7716a4514'
    'scripts/platform/UnixNative.cs' = '996a8e4cc1c795f4732a9d7368e597b838c801d0710e32629cafcbba89f8c004'
    'scripts/platform/WindowsNative.cs' = '6eea8ca2701b6a6de88ee4a3348f053d07a0543d607832e667335c838bb7d433'
    'scripts/platform/WindowsInstallerMutation.cs' = 'b88b4b09c7bb5c3e71b762ddc6ebe72007ed0cca99977ab7a7272529c3ff9218'
    'scripts/platform/OwnedProcess.cs' = '097061ad5902f896ff74b3f60b0ecaf63f3d58f357aed8fdbf80a8586564de58'
    'scripts/platform/UnixProcess.cs' = '125d2b3eecdad6a6c201d5f5d61a6efd0ad55ba93822c7b83a679a5397005db1'
    'scripts/platform/WindowsProcess.cs' = '7b8a0cddd3b9809b861801fe1d6a618684e2ca6fa13f9334825c5c9da5b2d8d6'
    'scripts/platform/Unix.psm1' = 'ec3b3bb0b39e1ce84d4c8f60a78c44fb40cb9d58c13ed88a6b9d9db978fcc147'
    'scripts/platform/RuntimePreparation.psm1' = 'dc254c04e7e2caf280726e66f67434776bc7df12a210a38c80596e41344fd077'
    'scripts/platform/Windows.psm1' = '9b7442178083a9b165ed3bf53367d5c3ce1b1f09d56f0f6efe964b524e17be0b'
    'scripts/platform/Linux.psm1' = '52c261d577ee7b3946771d1112030996896fdd119e06ac3849e430a3d56fb38c'
    'scripts/platform/MacOS.psm1' = '8f25edfbee5ab36b5e1c42eb55c6dbab44db0bc29896c180612b1248920c7c47'
}

$script:KnowledgeContentApprovedAuthorityCommit = '472cbd6f533d3f6d0a5381862128ebcc87618a7c'
$script:KnowledgeContentApprovedAuthorityArchiveSha256 = '357def24360566e9351af5c7b3bb8b8a7989f9ccb1eaf6f2401fa33e4069d8bf'
$script:KnowledgeContentApprovedAuthorityFiles = [ordered]@{
    'docs/standards/README.md' = '8aef64a9e69848c82d0ceba43f14c2876e3816cbc4761bac26a35e6f62aaf884'
    'docs/standards/managed-skill-lifecycle.md' = '4e3f8595072d663f51d18aa28f42293fda5456362b49c0ea3f0157ae3dcf56dd'
    'docs/standards/schemas/managed-skill-lifecycle-v1.schema.json' = '9a7f4c02588d2b88194e953a41766a72a9426fa89d4c3781c5750dcc22d35863'
    'docs/standards/schemas/openai-agent-metadata.schema.json' = '23c1aaee28a54fea1946a61d6122a2097906ffa5bdd66c8014fc6b1625c9062a'
    'docs/standards/schemas/source-inventory-v2.schema.json' = '084550944b4141ab5535f58fb6e99730a5c34b56103f6b59fd5a352679caa98e'
    'docs/standards/schemas/validation-security-gate-v1.schema.json' = 'b924b28a791f4d6eedcc0aa1c01fb62687ec863c0c17048093bfdd99aaa55b74'
    'docs/standards/skill-repository-review-matrix.md' = 'db0f898b2e59e0600abe3ec93684e561db339c82547d9035b18285f0285672ab'
    'docs/standards/skill-repository-standard.md' = 'a831a4151f8ea31e90709487af7823256ca4b119784823216a89ee8fcc85da35'
    'docs/standards/upstream-interoperability.md' = '8e48cc4831d151ffa4665433d79ad88e8871cb1d694861908dd0206406dcefe5'
    'docs/standards/validation-security-gate.json' = '1ab4c1208885a3aeb74654d8133426367134446e2b7519f06e63de3a53b16067'
    'docs/standards/validation-toolchain.json' = '001054854960563201d969a826db990f01ab93a2e87120ccc5ee42be8f8417d7'
    'scripts/Invoke-StandardAuthorityGate.ps1' = 'b4972681e79f788485e3925b737a7b0faac38a63c617450472758f2cc33798ef'
    'scripts/Resolve-PythonWheelClosure.py' = '45bd49b13acaee461ac38cbdd303016d74f516ae494d77cbd127366603c90681'
    'scripts/Resolve-StandardValidationTool.ps1' = 'c0d68b227fc04e19d710a89c4559fe45e0cc979eead846006261dc2dc5bfa14f'
    'docs/standards/schemas/standard-validation-adapter-v1.schema.json' = '11aa88fc25716d748bd4f514f1a44f02390ad1745dd5a5c5beee07f642fd5639'
    'docs/standards/schemas/standard-validation-evidence-v1.schema.json' = 'e177a6832d055b51a440615fec65d01941b1b0c32bf468b962c8eb79750db924'
    'docs/standards/standard-validation-contract-v1.json' = '2fa394ee48f940cdc2272c64199b90d95dea3665e1496df49cd0bd695cbdbe15'
    'docs/standards/pr12-source-merge-adoption.json' = '4c5262f2a11d228195230c15fa4faaf9614af6b59f110e5d9c08f242ce809175'
    'docs/standards/trust-anchors/human-approval-public-key.xml' = '1e46153b72d02f3ce2fb26becd449df4f1590d8e5cb441b1954006a5602bbd9b'
    'docs/standards/trust-anchors/trusted-supervisor-public-key.xml' = '4d550851f43405920156f40c9fc648d99a69dd73efc200f6968d8a837e7fbf27'
    'scripts/Invoke-StandardValidation.ps1' = '242b9e856d11dffffc512d03b60a7bd1f8ebad101d99cd97556488201b504350'
    'docs/standards/schemas/standard-semantic-consent-evidence-v2.schema.json' = '109091979d0a47e2035d3d8b20963fcdb85680e5da737bf1f27121608115d430'
    'scripts/StandardSemanticBridge.psm1' = '92595bdbb98ae77bdb2cc4dd7605ecc29f54e0a6746c9ee7d7636655f65665ef'
    'docs/standards/schemas/upstream-adapter-v1.schema.json' = '3cff6246463188a91cc54c6a46315a949314767a759c6214e5b28e4db95ac8d7'
    'docs/standards/upstream-adapter.json' = 'c4f5133b24841bb9c66182dc3d5a027596f864ec28e410d47249a67b3b97ad31'
    'scripts/Validate-UpstreamAdapter.ps1' = '3b6e6474690b1ae9f9486544b68f50ca29b96f5dbe6aa8d6c6cd8570afad500b'
    'docs/standards/standard-core-validation-v2.json' = 'dd3c3d1bb83a439895ed35a949ff376b9d59d25e69063c86714eb42edaad84df'
    'docs/standards/schemas/standard-core-adapter-v2.schema.json' = '7399980e8765528b759a3734a133447eb9581ac24a9c4780dc8faadd6af0c1c5'
    'docs/standards/schemas/standard-core-evidence-v2.schema.json' = '7c083b9603b75518220e7e70e5704728a7e3dee0d5b5cf09dc9c755f49d64153'
    'docs/standards/third-party-raw-skill-sources.md' = '18649fd56eada4a94a5d47de778669b0ebcecfb85b84f5c581d283b21979f7ac'
    'docs/standards/schemas/third-party-raw-skill-source-v1.schema.json' = '9d8585d95c606486f947a3f89e39341af840335376e86910eb7f4ed25bdc16ed'
    'docs/standards/examples/third-party-raw-skill-source-v1.json' = 'decbf276cbeea33c60d8b36b7b16838babe951cd84d13ae4a8a7a8261dc6d9c8'
    'docs/standards/skillspector-approved-sources.json' = 'baaaf2a66e98f2c28a48fddd04051f09cf5498ef6c7978cbf45f5d415b69a330'
    'docs/standards/schemas/skillspector-approved-sources-v1.schema.json' = '20fa8516c9dcb7c9ae15f4682092dc583411db3149fac2641fef7b5182c3d12b'
    'docs/standards/static-parser-host-ownership.json' = '994acd989327d094d22ce2c68ca20eceec609f4e494f4e5d252cfcdef742de2c'
    'scripts/platform-runtime.psd1' = '7f112390d2995a105b9e9a916876df1779485dec6df21d7516243e2dcd1c4dca'
    'scripts/platform-runtime.psm1' = 'ad051b2794ce4dc10108404201735d02f7b032ed0e633c5f22f73c884fb10370'
    'scripts/installer-safe-mutation.psm1' = 'dc031edcc2f48968df83cd68ad52eacb7f7b05d3ca6a0cc622658cf6151c8293'
    'scripts/WindowsDacl.psm1' = 'ffa1f85d94bb6bce9bf8353f8c7733bdbe59880a3d0d075191938cc28aebb5f6'
    'scripts/platform/PlatformNative.cs' = 'f9da23bf3e6e3c8960b26d534e14873f6b4fc98b3d13f5b6cdfdd5f7716a4514'
    'scripts/platform/UnixNative.cs' = '996a8e4cc1c795f4732a9d7368e597b838c801d0710e32629cafcbba89f8c004'
    'scripts/platform/WindowsNative.cs' = '6eea8ca2701b6a6de88ee4a3348f053d07a0543d607832e667335c838bb7d433'
    'scripts/platform/WindowsInstallerMutation.cs' = 'b88b4b09c7bb5c3e71b762ddc6ebe72007ed0cca99977ab7a7272529c3ff9218'
    'scripts/platform/OwnedProcess.cs' = '097061ad5902f896ff74b3f60b0ecaf63f3d58f357aed8fdbf80a8586564de58'
    'scripts/platform/UnixProcess.cs' = '125d2b3eecdad6a6c201d5f5d61a6efd0ad55ba93822c7b83a679a5397005db1'
    'scripts/platform/WindowsProcess.cs' = '7b8a0cddd3b9809b861801fe1d6a618684e2ca6fa13f9334825c5c9da5b2d8d6'
    'scripts/platform/Unix.psm1' = 'ec3b3bb0b39e1ce84d4c8f60a78c44fb40cb9d58c13ed88a6b9d9db978fcc147'
    'scripts/platform/RuntimePreparation.psm1' = 'dc254c04e7e2caf280726e66f67434776bc7df12a210a38c80596e41344fd077'
    'scripts/platform/Windows.psm1' = '9b7442178083a9b165ed3bf53367d5c3ce1b1f09d56f0f6efe964b524e17be0b'
    'scripts/platform/Linux.psm1' = '52c261d577ee7b3946771d1112030996896fdd119e06ac3849e430a3d56fb38c'
    'scripts/platform/MacOS.psm1' = '8f25edfbee5ab36b5e1c42eb55c6dbab44db0bc29896c180612b1248920c7c47'
}

function Assert-KnowledgeContentExactPropertySet {
    param(
        [Parameter(Mandatory = $true)] $Value,
        [Parameter(Mandatory = $true)][string[]] $Expected,
        [Parameter(Mandatory = $true)][string] $Context
    )

    if ($null -eq $Value -or $Value -is [array] -or $Value -is [string] -or $null -eq $Value.PSObject) {
        throw "$Context must be a JSON object."
    }
    $actual = @($Value.PSObject.Properties | ForEach-Object { [string]$_.Name })
    $missing = @($Expected | Where-Object { $actual -cnotcontains $_ })
    $unexpected = @($actual | Where-Object { $Expected -cnotcontains $_ })
    if ($missing.Count -gt 0 -or $unexpected.Count -gt 0 -or $actual.Count -ne $Expected.Count) {
        throw "$Context has an invalid property set. Missing='$($missing -join ',')' Unexpected='$($unexpected -join ',')'."
    }
}

function Get-KnowledgeContentPreparedAuthorityPin {
    [CmdletBinding()]
    param(
        [ValidateSet('6cee5b8e43fe4e327fedc788865f931c561d6e89', 'ead467c3488c103546f316d137196b447a1ff58a', '472cbd6f533d3f6d0a5381862128ebcc87618a7c', IgnoreCase = $false)]
        [string] $Commit = $script:KnowledgeContentPreparedAuthorityCommit
    )

    $authorityFiles = $script:KnowledgeContentPreparedAuthorityFiles
    $archiveSha256 = $script:KnowledgeContentPreparedAuthorityArchiveSha256
    if ($Commit -ceq $script:KnowledgeContentActiveAuthorityCommit) {
        $authorityFiles = $script:KnowledgeContentActiveAuthorityFiles
        $archiveSha256 = $script:KnowledgeContentActiveAuthorityArchiveSha256
    }
    elseif ($Commit -ceq $script:KnowledgeContentApprovedAuthorityCommit) {
        $authorityFiles = $script:KnowledgeContentApprovedAuthorityFiles
        $archiveSha256 = $script:KnowledgeContentApprovedAuthorityArchiveSha256
    }
    $files = [ordered]@{}
    foreach ($entry in $authorityFiles.GetEnumerator()) {
        $files[[string]$entry.Key] = [string]$entry.Value
    }
    return [pscustomobject][ordered]@{
        repository = $script:KnowledgeContentPreparedAuthorityRepository
        commit = $Commit
        archiveUrl = "https://codeload.github.com/SyuanTsai/SyuanTsai-AI-Instructions/zip/$Commit"
        archiveSha256 = $archiveSha256
        files = $files
    }
}

function Assert-KnowledgeContentPreparedAuthorityTuple {
    [CmdletBinding()]
    param([Parameter(Mandatory = $true)] $Authority)

    Assert-KnowledgeContentExactPropertySet -Value $Authority `
        -Expected @('repository', 'commit', 'archiveUrl', 'archiveSha256', 'files') `
        -Context 'Prepared source authority'

    $expected = Get-KnowledgeContentPreparedAuthorityPin -Commit $Authority.commit
    foreach ($field in @('repository', 'commit', 'archiveUrl', 'archiveSha256')) {
        if ($Authority.$field -isnot [string] -or [string]$Authority.$field -cne [string]$expected.$field) {
            throw "Prepared source authority $field does not match the exact approved tuple."
        }
    }
    if ($Authority.files -isnot [array] -or @($Authority.files).Count -ne $expected.files.Count) {
        throw 'Prepared source authority file tuple is incomplete.'
    }

    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $expectedPaths = @($expected.files.Keys)
    for ($index = 0; $index -lt $expectedPaths.Count; $index++) {
        $file = @($Authority.files)[$index]
        Assert-KnowledgeContentExactPropertySet -Value $file -Expected @('path', 'sha256') `
            -Context "Prepared source authority file at index $index"
        if ($file.path -isnot [string] -or $file.sha256 -isnot [string]) {
            throw "Prepared source authority file fields must be strings at index $index."
        }

        $path = [string]$file.path
        if ([string]::IsNullOrWhiteSpace($path) -or $path.StartsWith('/', [StringComparison]::Ordinal) -or
            $path.Contains('\') -or $path.Contains(':') -or
            @($path.Split('/')) -contains '' -or @($path.Split('/')) -contains '.' -or @($path.Split('/')) -contains '..') {
            throw "Prepared source authority contains an unsafe file path at index $index."
        }
        if (-not $seen.Add($path)) { throw "Prepared source authority contains duplicate file path '$path'." }
        if ([string]$file.sha256 -cnotmatch '^[0-9a-f]{64}$') {
            throw "Prepared source authority file SHA-256 is invalid at index $index."
        }
        if ($path -cne [string]$expectedPaths[$index]) {
            throw "Prepared source authority file path or order mismatch at index $index."
        }
        if ([string]$file.sha256 -cne [string]$expected.files[$path]) {
            throw "Prepared source authority file identity mismatch at index $index."
        }
    }
    return $expected
}

function Assert-KnowledgeContentSourceRequest {
    [CmdletBinding()]
    param(
        [switch] $PrepareSourceTools,
        [switch] $SourceValidation,
        [string] $SourceToolsPath,
        [string] $AuthorityRepositoryRoot,
        [string] $TrustedToolRoot,
        $AuthorityArchivePath,
        $CandidateAuthority,
        [System.Collections.IDictionary] $BoundParameters
    )

    if ($PrepareSourceTools -and $SourceValidation) {
        throw 'PrepareSourceTools and SourceValidation are separate setup and execution requests.'
    }
    $hasSourcePurpose = $PrepareSourceTools -or $SourceValidation
    if (-not $hasSourcePurpose) {
        if (-not [string]::IsNullOrWhiteSpace($SourceToolsPath) -or
            -not [string]::IsNullOrWhiteSpace($AuthorityRepositoryRoot) -or
            -not [string]::IsNullOrWhiteSpace($TrustedToolRoot) -or
            ($null -ne $BoundParameters -and
                @($BoundParameters.Keys | Where-Object { $_ -cin @('SourceToolsPath', 'AuthorityRepositoryRoot', 'TrustedToolRoot') }).Count -gt 0)) {
            throw 'Source tools and authority roots are only valid for explicit source setup or validation.'
        }
        return
    }
    if (-not [string]::IsNullOrWhiteSpace($AuthorityArchivePath) -or
        ($null -ne $BoundParameters -and $BoundParameters.Keys -contains 'AuthorityArchivePath')) {
        throw 'Explicit source setup or validation does not accept AuthorityArchivePath.'
    }
    if ([string]::IsNullOrWhiteSpace($SourceToolsPath)) { throw 'Explicit source setup or validation requires SourceToolsPath.' }
    if ([string]::IsNullOrWhiteSpace($AuthorityRepositoryRoot)) { throw 'Explicit source setup or validation requires AuthorityRepositoryRoot.' }
    if ([string]::IsNullOrWhiteSpace($TrustedToolRoot)) { throw 'Explicit source setup or validation requires TrustedToolRoot.' }

    if ($SourceValidation -or $null -ne $CandidateAuthority) {
        if ($null -eq $CandidateAuthority) { throw 'SourceValidation requires the exact prepared candidate authority tuple.' }
        [void](Assert-KnowledgeContentPreparedAuthorityTuple -Authority $CandidateAuthority)
    }
}

function Resolve-KnowledgeContentSourceRoute {
    [CmdletBinding()]
    param(
        [switch] $PrepareSourceTools,
        [switch] $SourceValidation,
        [string] $SourceToolsPath,
        [string] $AuthorityRepositoryRoot,
        [string] $TrustedToolRoot,
        [string] $AuthorityArchivePath,
        $CandidateAuthority,
        [System.Collections.IDictionary] $BoundParameters
    )

    Assert-KnowledgeContentSourceRequest -PrepareSourceTools:$PrepareSourceTools -SourceValidation:$SourceValidation -SourceToolsPath $SourceToolsPath -AuthorityRepositoryRoot $AuthorityRepositoryRoot -TrustedToolRoot $TrustedToolRoot -AuthorityArchivePath $AuthorityArchivePath -CandidateAuthority $CandidateAuthority -BoundParameters $BoundParameters

    if ($PrepareSourceTools) {
        $pin = if ($null -eq $CandidateAuthority) { Get-KnowledgeContentPreparedAuthorityPin }
               else { Assert-KnowledgeContentPreparedAuthorityTuple -Authority $CandidateAuthority }
        return [pscustomobject]@{ mode = 'prepare-source-tools'; authority = $pin }
    }
    if ($SourceValidation) {
        return [pscustomobject]@{ mode = 'source-validation'; authority = Assert-KnowledgeContentPreparedAuthorityTuple -Authority $CandidateAuthority }
    }
    return [pscustomobject]@{ mode = 'ordinary'; authority = $CandidateAuthority }
}

function Assert-KnowledgeContentPreparedAuthorityCheckout {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $GitPath,
        [Parameter(Mandatory = $true)][string] $AuthorityRoot,
        [Parameter(Mandatory = $true)] $AuthorityPin
    )

    $fullRoot = [IO.Path]::GetFullPath($AuthorityRoot)
    if (-not (Test-Path -LiteralPath $fullRoot -PathType Container)) { throw "Prepared authority Git checkout is missing: $fullRoot" }
    Assert-NoReparseAncestors -Path $fullRoot -Context 'Prepared authority checkout'
    $top = @(& $GitPath -C $fullRoot rev-parse --show-toplevel 2>$null)
    if ($LASTEXITCODE -ne 0 -or $top.Count -ne 1 -or -not (Test-KnowledgeContentPathEqual -Left ([string]$top[0]) -Right $fullRoot)) {
        throw 'Prepared authority path is not the root of a Git checkout.'
    }
    $head = @(& $GitPath -C $fullRoot rev-parse --verify --end-of-options 'HEAD^{commit}' 2>$null)
    if ($LASTEXITCODE -ne 0 -or $head.Count -ne 1 -or ([string]$head[0]).Trim() -cne [string]$AuthorityPin.commit) {
        throw 'Prepared authority checkout HEAD does not match the exact approved revision.'
    }
    $origins = @(& $GitPath -C $fullRoot config --local --get-all remote.origin.url 2>$null)
    if ($LASTEXITCODE -ne 0 -or $origins.Count -ne 1) { throw 'Prepared authority checkout must have exactly one origin URL.' }
    $origin = ([string]$origins[0]).Trim().TrimEnd('/') -replace '\.git$', ''
    $expectedOrigin = ([string]$AuthorityPin.repository).Trim().TrimEnd('/') -replace '\.git$', ''
    if (-not $origin.Equals($expectedOrigin, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Prepared authority checkout origin does not match the pinned authority repository.'
    }
    $dirty = @(& $GitPath -C $fullRoot status --porcelain=v1 --untracked-files=all)
    if ($LASTEXITCODE -ne 0 -or $dirty.Count -ne 0) { throw 'Prepared authority checkout must be clean and immutable.' }

    foreach ($entry in $AuthorityPin.files.GetEnumerator()) {
        $filePath = [IO.Path]::GetFullPath((Join-Path $fullRoot ($entry.Key -replace '/', [IO.Path]::DirectorySeparatorChar)))
        if (-not (Test-PathWithinOrEqual -Path $filePath -Root $fullRoot)) { throw "Prepared authority file escaped its checkout: $($entry.Key)" }
        Assert-NoReparseAncestors -Path $filePath -Context 'Prepared authority file'
        if (-not (Test-Path -LiteralPath $filePath -PathType Leaf) -or (Get-FileSha256 -Path $filePath) -cne [string]$entry.Value) {
            throw "Prepared authority file identity mismatch: $($entry.Key)"
        }
        $treeEntry = @(& $GitPath -C $fullRoot ls-tree $head -- ([string]$entry.Key) 2>$null)
        if ($LASTEXITCODE -ne 0 -or $treeEntry.Count -ne 1 -or
            [string]$treeEntry[0] -cnotmatch ('^(?<mode>100644|100755) blob (?<objectId>[0-9a-f]{40})\t' + [regex]::Escape([string]$entry.Key) + '$')) {
            throw "Prepared authority path is not a regular Git blob: $($entry.Key)"
        }
        $expectedBlob = [string]$Matches.objectId
        $actualBlob = @(& $GitPath -C $fullRoot hash-object --no-filters -- ([string]$entry.Key) 2>$null)
        if ($LASTEXITCODE -ne 0 -or $actualBlob.Count -ne 1 -or ([string]$actualBlob[0]).Trim() -cne $expectedBlob) {
            throw "Prepared authority file bytes differ from its immutable Git blob: $($entry.Key)"
        }
    }
    return [pscustomobject]@{ root = $fullRoot; revision = [string]$AuthorityPin.commit; runnerPath = (Join-Path $fullRoot 'scripts/Invoke-StandardValidation.ps1') }
}

function New-KnowledgeContentCoreAuthoritySnapshot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $GitPath,
        [Parameter(Mandatory = $true)][string] $SourceRoot,
        [Parameter(Mandatory = $true)][string] $OwnedRoot,
        [Parameter(Mandatory = $true)] $AuthorityPin
    )

    $ownedFull = [IO.Path]::GetFullPath($OwnedRoot)
    Assert-NoReparseAncestors -Path $ownedFull -Context 'Core Pester adapter root'
    $snapshotRoot = Assert-PathWithinRoot -Path (Join-Path $ownedFull 'authority') -Root $ownedFull -Context 'Core Pester authority snapshot'
    if (Test-Path -LiteralPath $snapshotRoot) { throw 'Core Pester authority snapshot path already exists.' }
    $hooksRoot = Join-Path $ownedFull '.empty-git-hooks'
    [void](New-Item -ItemType Directory -Path $hooksRoot -ErrorAction Stop)
    Assert-NoReparseAncestors -Path $hooksRoot -Context 'Core Pester authority snapshot hooks'

    # Use an isolated, no-hardlink Git clone so the child test process can bind
    # its authority root to the exact prepared revision without sharing files.
    & $GitPath -c "core.hooksPath=$hooksRoot" -c maintenance.auto=false -c gc.auto=0 -c core.autocrlf=false -c core.longpaths=true clone --quiet --local --no-hardlinks --no-checkout -- $SourceRoot $snapshotRoot
    if ($LASTEXITCODE -ne 0) { throw 'Could not materialize the no-hardlink authority Git snapshot for Core Pester.' }
    & $GitPath -C $snapshotRoot config --local maintenance.auto false
    if ($LASTEXITCODE -ne 0) { throw 'Could not disable maintenance.auto in the Core Pester authority snapshot.' }
    & $GitPath -C $snapshotRoot config --local maintenance.autoDetach false
    if ($LASTEXITCODE -ne 0) { throw 'Could not disable maintenance.autoDetach in the Core Pester authority snapshot.' }
    & $GitPath -C $snapshotRoot config --local gc.auto 0
    if ($LASTEXITCODE -ne 0) { throw 'Could not disable gc.auto in the Core Pester authority snapshot.' }
    & $GitPath -C $snapshotRoot config --local gc.autoDetach false
    if ($LASTEXITCODE -ne 0) { throw 'Could not disable gc.autoDetach in the Core Pester authority snapshot.' }
    if (([string](& $GitPath -C $snapshotRoot config --local --get maintenance.auto)).Trim() -cne 'false' -or
        ([string](& $GitPath -C $snapshotRoot config --local --get gc.auto)).Trim() -cne '0') {
        throw 'Core Pester authority snapshot Git maintenance configuration was not applied.'
    }
    & $GitPath -C $snapshotRoot config --local core.autocrlf false
    if ($LASTEXITCODE -ne 0) { throw 'Could not disable line-ending conversion in the Core Pester authority snapshot.' }
    & $GitPath -C $snapshotRoot config --local core.longpaths true
    if ($LASTEXITCODE -ne 0) { throw 'Could not enable long paths in the Core Pester authority snapshot.' }
    $snapshotPaths = @($AuthorityPin.files.Keys) + @('docs/standards/standard-core-validation-v2.json')
    $snapshotPaths = @($snapshotPaths | Select-Object -Unique)
    & $GitPath -c "core.hooksPath=$hooksRoot" -C $snapshotRoot sparse-checkout set --no-cone -- $snapshotPaths
    if ($LASTEXITCODE -ne 0) { throw 'Could not select the pinned files in the Core Pester authority snapshot.' }
    & $GitPath -C $snapshotRoot config --local --replace-all remote.origin.url ([string]$AuthorityPin.repository)
    if ($LASTEXITCODE -ne 0) { throw 'Could not bind the Core Pester authority snapshot origin.' }
    & $GitPath -c "core.hooksPath=$hooksRoot" -c core.autocrlf=false -C $snapshotRoot checkout --quiet --detach ([string]$AuthorityPin.commit)
    if ($LASTEXITCODE -ne 0) { throw 'Could not check out the exact prepared authority revision for Core Pester.' }
    return Assert-KnowledgeContentPreparedAuthorityCheckout -GitPath $GitPath -AuthorityRoot $snapshotRoot -AuthorityPin $AuthorityPin
}

function Remove-KnowledgeContentOwnedCoreAdapterRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $OwnedRoot,
        [Parameter(Mandatory = $true)][string] $ArtifactsRoot,
        [Parameter(Mandatory = $true)][string] $RunId,
        [Parameter(Mandatory = $true)][string] $OwnerToken,
        [Parameter(Mandatory = $true)][string] $RepositoryRoot,
        [Parameter(Mandatory = $true)][string] $AuthorityRoot,
        [Parameter(Mandatory = $true)][string] $TrustedToolRoot,
        [Parameter(Mandatory = $true)][string] $CoreArtifactsRoot
    )

    if ($RunId -cnotmatch '^[0-9a-f]{32}$' -or $OwnerToken -cnotmatch '^[0-9a-f]{32}$') { throw 'Core Pester adapter cleanup identity is invalid.' }
    $expectedRoot = [IO.Path]::GetFullPath((Join-Path $ArtifactsRoot ".core-v2-adapter-$RunId"))
    $ownedFull = [IO.Path]::GetFullPath($OwnedRoot)
    if (-not (Test-KnowledgeContentPathEqual -Left $ownedFull -Right $expectedRoot) -or
        -not (Test-KnowledgeContentPathEqual -Left (Split-Path -Parent $ownedFull) -Right $ArtifactsRoot)) {
        throw 'Core Pester adapter cleanup path is not the exact run-owned sibling.'
    }
    if (-not (Test-Path -LiteralPath $ownedFull -PathType Container)) { return }
    Assert-OutsideRoot -Path $ownedFull -Root $RepositoryRoot -Context 'Core Pester adapter cleanup root'
    Assert-OutsideRoot -Path $ownedFull -Root $AuthorityRoot -Context 'Core Pester adapter cleanup root'
    Assert-OutsideRoot -Path $ownedFull -Root $TrustedToolRoot -Context 'Core Pester adapter cleanup root'
    Assert-OutsideRoot -Path $ownedFull -Root $CoreArtifactsRoot -Context 'Core Pester adapter cleanup root'
    Assert-NoReparseAncestors -Path $ownedFull -Context 'Core Pester adapter cleanup root'

    $markerPath = Join-Path $ownedFull '.source-owned.json'
    if (-not (Test-Path -LiteralPath $markerPath -PathType Leaf)) { throw 'Core Pester adapter cleanup ownership marker is missing.' }
    Assert-NoReparseAncestors -Path $markerPath -Context 'Core Pester adapter cleanup marker'
    $marker = Read-JsonFile -Path $markerPath -Context 'Core Pester adapter cleanup marker'
    Assert-KnowledgeContentExactPropertySet -Value $marker -Expected @('owner', 'runId', 'token') -Context 'Core Pester adapter cleanup marker'
    if ([string]$marker.owner -cne 'knowledge-content-source-core-adapter' -or
        [string]$marker.runId -cne $RunId -or [string]$marker.token -cne $OwnerToken) {
        throw 'Core Pester adapter cleanup marker does not match this source run.'
    }
    foreach ($item in @(Get-ChildItem -LiteralPath $ownedFull -Recurse -Force -ErrorAction Stop)) {
        if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw "Core Pester adapter cleanup found a reparse point: $($item.FullName)" }
    }
    Remove-Item -LiteralPath $ownedFull -Recurse -Force -ErrorAction Stop
    if (Test-Path -LiteralPath $ownedFull) { throw 'Core Pester adapter cleanup did not remove its exact run-owned root.' }
}

function Get-KnowledgeContentCorePesterLayout {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $ArtifactsRoot,
        [Parameter(Mandatory = $true)][string] $RunId
    )

    if ($RunId -cnotmatch '^[0-9a-f]{32}$') { throw 'Core Pester layout requires the canonical source setup RunId.' }
    $root = [IO.Path]::GetFullPath($ArtifactsRoot)
    $adapterRoot = [IO.Path]::GetFullPath((Join-Path $root ".core-v2-adapter-$RunId"))
    if (-not (Test-KnowledgeContentPathEqual -Left (Split-Path -Parent $adapterRoot) -Right $root)) {
        throw 'Core Pester adapter layout must be a direct ArtifactsRoot child.'
    }
    return [pscustomobject][ordered]@{
        adapterRoot = $adapterRoot
        adapterPath = [IO.Path]::GetFullPath((Join-Path $adapterRoot 'standard-core-adapter-v2.json'))
        authorityRoot = [IO.Path]::GetFullPath((Join-Path $adapterRoot 'authority'))
        ownerMarkerPath = [IO.Path]::GetFullPath((Join-Path $adapterRoot '.source-owned.json'))
    }
}

function New-KnowledgeContentSourceCoreAdapter {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $PowerShell,
        [Parameter(Mandatory = $true)][string] $RunId,
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][string[]] $ActiveSkillIds,
        [Parameter(Mandatory = $true)] $SourceValidation
    )

    if ($RunId -cnotmatch '^[0-9a-f]{32}$') { throw 'Core source adapter requires the canonical source setup RunId.' }
    $fullPowerShell = [IO.Path]::GetFullPath($PowerShell)
    if (-not (Test-Path -LiteralPath $fullPowerShell -PathType Leaf)) { throw 'Core source adapter PowerShell executable is missing.' }
    if ($ActiveSkillIds.Count -eq 0) { throw 'Core source adapter requires at least one active Skill.' }
    foreach ($skillId in $ActiveSkillIds) {
        if ([string]$skillId -cnotmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$') { throw "Core source adapter contains an invalid Skill ID: '$skillId'." }
    }
    $powerShellSha256 = Get-FileSha256 -Path $fullPowerShell
    return [ordered]@{
        schemaVersion = 2
        adapter = 'standard-core-adapter-v2'
        skillsRoot = 'skills'
        activeSkills = @($ActiveSkillIds)
        checks = @(
            [ordered]@{ id = 'repository-general'; kind = 'general'; executable = $fullPowerShell; executableSha256 = $powerShellSha256; arguments = @('-NoProfile', '-NonInteractive', '-File', 'scripts/Test-Repository.ps1', '-ReadOnlySnapshot') }
            [ordered]@{ id = 'repository-pester'; kind = 'pester'; executable = $fullPowerShell; executableSha256 = $powerShellSha256; arguments = @('-NoProfile', '-NonInteractive', '-File', 'scripts/Invoke-CorePester.ps1', '-CandidateAuthorityAdapterRunId', $RunId) }
        )
        sourceValidation = $SourceValidation
    }
}

function Write-KnowledgeContentUtf8CreateNew {
    param(
        [Parameter(Mandatory = $true)][string] $Path,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string] $Text
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    $parent = Split-Path -Parent $fullPath
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        throw "Create-only source setup parent directory is missing: $parent"
    }
    $bytes = [Text.UTF8Encoding]::new($false).GetBytes($Text)
    $stream = [IO.FileStream]::new($fullPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try {
        $stream.Write($bytes, 0, $bytes.Length)
        $stream.Flush($true)
    }
    finally { $stream.Dispose() }
}

function Assert-KnowledgeContentSourceReceiptClosureFrozen {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]] $Bindings,
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][object[]] $FrozenFiles
    )

    if ($Bindings.Count -ne 3) { throw 'Source setup requires exactly three resolver receipts.' }
    $comparison = if ($IsWindows) { [StringComparer]::OrdinalIgnoreCase } else { [StringComparer]::Ordinal }
    $seenFrozen = [Collections.Generic.HashSet[string]]::new($comparison)
    foreach ($file in $FrozenFiles) {
        Assert-KnowledgeContentExactPropertySet -Value $file -Expected @('path', 'sha256') -Context 'Source frozen file'
        if ([string]$file.path -cne [IO.Path]::GetFullPath([string]$file.path) -or
            [string]$file.sha256 -cnotmatch '^[0-9a-f]{64}$' -or -not $seenFrozen.Add([string]$file.path)) {
            throw 'Source frozen files must have unique absolute paths and lowercase SHA-256 identities.'
        }
    }

    $seenTools = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($binding in $Bindings) {
        Assert-KnowledgeContentExactPropertySet -Value $binding -Expected @('path', 'sha256') -Context 'Source tool receipt binding'
        $receiptPath = [IO.Path]::GetFullPath([string]$binding.path)
        if ([string]$binding.sha256 -cnotmatch '^[0-9a-f]{64}$' -or
            (Get-FileHash -LiteralPath $receiptPath -Algorithm SHA256 -ErrorAction Stop).Hash.ToLowerInvariant() -cne [string]$binding.sha256) {
            throw 'Source tool receipt does not match its frozen SHA-256 binding.'
        }
        $receiptFrozen = @($FrozenFiles | Where-Object {
            (Test-KnowledgeContentPathEqual -Left ([string]$_.path) -Right $receiptPath) -and [string]$_.sha256 -ceq [string]$binding.sha256
        })
        if ($receiptFrozen.Count -ne 1) { throw 'Source tool receipt file is not frozen exactly once.' }

        $receiptText = [IO.File]::ReadAllText($receiptPath, [Text.UTF8Encoding]::new($false, $true))
        $receipt = ConvertFrom-Json -InputObject $receiptText -Depth 50 -ErrorAction Stop
        $toolName = [string]$receipt.toolName
        if ($toolName -cnotin @('skill-validator', 'skill-tools', 'skillspector') -or -not $seenTools.Add($toolName)) {
            throw 'Source tool receipts must identify each approved tool exactly once.'
        }
        $pairs = [Collections.Generic.List[object]]::new()
        if ($toolName -ceq 'skill-tools') {
            $pairs.Add(@('entryPointPath', 'entryPointSha256'))
            $pairs.Add(@('nodePath', 'nodeSha256'))
        }
        else {
            $pairs.Add(@('executablePath', 'executableSha256'))
        }
        foreach ($pair in $pairs) {
            $pathProperty = $receipt.PSObject.Properties[[string]$pair[0]]
            $hashProperty = $receipt.PSObject.Properties[[string]$pair[1]]
            if ($null -eq $pathProperty -or $null -eq $hashProperty -or
                $pathProperty.Value -isnot [string] -or $hashProperty.Value -isnot [string] -or
                [string]$hashProperty.Value -cnotmatch '^[0-9a-f]{64}$' -or
                -not [IO.Path]::IsPathRooted([string]$pathProperty.Value)) {
                throw "Source $toolName receipt has an invalid $($pair[0]) frozen identity."
            }
            $frozenMatches = @($FrozenFiles | Where-Object {
                (Test-KnowledgeContentPathEqual -Left ([string]$_.path) -Right ([string]$pathProperty.Value)) -and
                [string]$_.sha256 -ceq [string]$hashProperty.Value
            })
            if ($frozenMatches.Count -ne 1) {
                throw "Source $toolName receipt $($pair[0]) is not frozen exactly once."
            }
        }
    }
}

function Write-KnowledgeContentSourceSetupArtifact {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $Path,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string] $Text,
        [AllowEmptyString()][string] $ProtectedToken
    )

    if (-not [string]::IsNullOrEmpty($ProtectedToken) -and $Text.Contains($ProtectedToken, [StringComparison]::Ordinal)) {
        throw 'Source setup artifact content contains the protected resolver credential.'
    }
    Write-KnowledgeContentUtf8CreateNew -Path $Path -Text $Text
}

function New-KnowledgeContentSourceToolSetup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $Root,
        [Parameter(Mandatory = $true)][string] $AuthorityRoot,
        [Parameter(Mandatory = $true)] $AuthorityPin,
        [Parameter(Mandatory = $true)][string] $PowerShell,
        [Parameter(Mandatory = $true)][string] $CandidateRevision,
        [Parameter(Mandatory = $true)][string] $Git,
        [Parameter(Mandatory = $true)][string] $SourceCheckoutRoot,
        [Parameter(Mandatory = $true)][string] $PreparedPath,
        [Parameter(Mandatory = $true)][string] $GoVersion,
        [Parameter(Mandatory = $true)][int] $LimitSeconds,
        [hashtable] $ResolverEnvironment = @{}
    )

    $protectedToken = if ($ResolverEnvironment.ContainsKey('STANDARD_VALIDATION_GITHUB_API_TOKEN')) { [string]$ResolverEnvironment['STANDARD_VALIDATION_GITHUB_API_TOKEN'] } else { '' }
    $setupId = [guid]::NewGuid().ToString('N')
    $owned = [IO.Path]::GetFullPath((Join-Path $Root "source-tools-$setupId"))
    if (Test-Path -LiteralPath $owned) { throw 'Source setup root already exists.' }
    [void](New-Item -ItemType Directory -Path $owned -ErrorAction Stop)
    Assert-NoReparseAncestors -Path $owned -Context 'Source setup owned root'

    $runner = Join-Path $AuthorityRoot 'scripts/Invoke-StandardValidation.ps1'
    if (-not (Test-Path -LiteralPath $runner -PathType Leaf)) { throw 'Pinned source authority runner is missing.' }
    . $runner -DefineFunctionsOnly -CandidateRoot $AuthorityRoot -AdapterPath $PreparedPath -ArtifactsRoot $Root -SourceRepository $script:SourceRepository -SourceRevision $CandidateRevision -BaseRevision $CandidateRevision -AuthorityRevision ([string]$AuthorityPin.commit)

    $resolver = Join-Path $AuthorityRoot 'scripts/Resolve-StandardValidationTool.ps1'
    $policy = Join-Path $AuthorityRoot 'docs/standards/validation-toolchain.json'
    $receipts = [ordered]@{}
    $receiptBindings = @()
    foreach ($tool in @('skill-validator', 'skill-tools', 'skillspector')) {
        $receiptPath = Join-Path $owned "receipt-$tool.json"
        $resolverArguments = @('-NoProfile', '-NonInteractive', '-File', $resolver, '-PolicyPath', $policy, '-ToolName', $tool, '-Install', '-InstallRoot', (Join-Path $owned 'installed'), '-ExpectedGoRuntimeVersion', $GoVersion, '-RunId', $setupId, '-OutputPath', $receiptPath)
        $result = Invoke-StandardValidationProcess -Command $PowerShell -Arguments $resolverArguments -WorkingDirectory $owned -Environment $ResolverEnvironment -TimeoutSeconds $LimitSeconds -CoreLifecycleOnly
        Write-KnowledgeContentSourceSetupArtifact -Path (Join-Path $owned "setup-$tool-process.json") -Text (($result | ConvertTo-Json -Depth 30) + [Environment]::NewLine) -ProtectedToken $protectedToken
        if ($result.status -cne 'passed' -or $result.exitCode -ne 0 -or -not $result.cleanedUp) {
            throw "Source setup $tool failed: $($result.status), exit=$($result.exitCode), cleanup=$($result.cleanedUp). $($result.stderr)"
        }
        $receipts[$tool] = Read-JsonFile -Path $receiptPath -Context "$tool source receipt"
        $receiptBindings += [pscustomobject]@{ path = $receiptPath; sha256 = Get-FileSha256 -Path $receiptPath }
    }

    $toolchain = [ordered]@{
        centralRunnerPath = [IO.Path]::GetFullPath($runner)
        centralRunnerSha256 = Get-FileSha256 -Path $runner
        upstreamAdapterValidatorPath = [IO.Path]::GetFullPath((Join-Path $AuthorityRoot 'scripts/Validate-UpstreamAdapter.ps1'))
        upstreamAdapterValidatorSha256 = Get-FileSha256 -Path (Join-Path $AuthorityRoot 'scripts/Validate-UpstreamAdapter.ps1')
        upstreamPolicyPath = [IO.Path]::GetFullPath((Join-Path $AuthorityRoot 'docs/standards/upstream-adapter.json'))
        upstreamPolicySha256 = Get-FileSha256 -Path (Join-Path $AuthorityRoot 'docs/standards/upstream-adapter.json')
        skillValidatorPath = [string]$receipts.'skill-validator'.executablePath
        skillValidatorSha256 = [string]$receipts.'skill-validator'.executableSha256
        skillToolsNodePath = [string]$receipts.'skill-tools'.nodePath
        skillToolsNodeSha256 = [string]$receipts.'skill-tools'.nodeSha256
        skillToolsEntryPointPath = [string]$receipts.'skill-tools'.entryPointPath
        skillToolsEntryPointSha256 = [string]$receipts.'skill-tools'.entryPointSha256
        skillSpectorPath = [string]$receipts.skillspector.executablePath
        skillSpectorSha256 = [string]$receipts.skillspector.executableSha256
        skillSpectorReceiptPath = [string]$receiptBindings[2].path
        skillSpectorReceiptSha256 = [string]$receiptBindings[2].sha256
    }
    $toolchainPath = Join-Path $owned 'toolchain.json'
    Write-KnowledgeContentSourceSetupArtifact -Path $toolchainPath -Text (($toolchain | ConvertTo-Json -Depth 20) + [Environment]::NewLine) -ProtectedToken $protectedToken

    $wrapper = Join-Path $owned 'Invoke-KnowledgeContentValidationChild.ps1'
    Write-KnowledgeContentSourceSetupArtifact -Path $wrapper -Text $childRunnerText -ProtectedToken $protectedToken
    $archive = Join-Path $owned 'candidate.zip'
    & $Git -C $SourceCheckoutRoot archive --format=zip "--output=$archive" $CandidateRevision
    if ($LASTEXITCODE -ne 0) { throw 'Source setup could not archive the exact candidate.' }
    $arguments = @('-NoProfile', '-NonInteractive', '-File', $wrapper, '-ToolchainPath', $toolchainPath, '-ToolchainSha256', (Get-FileSha256 -Path $toolchainPath), '-SourceRepository', $script:SourceRepository, '-SourceRevision', $CandidateRevision, '-ArchiveSha256', (Get-FileSha256 -Path $archive))
    $frozenPaths = @($PowerShell, $wrapper, $toolchainPath, $runner, $toolchain.upstreamAdapterValidatorPath, $toolchain.upstreamPolicyPath, $toolchain.skillValidatorPath, $toolchain.skillToolsNodePath, $toolchain.skillToolsEntryPointPath, $toolchain.skillSpectorPath) + @($receiptBindings | ForEach-Object { [string]$_.path })
    $frozen = @(foreach ($file in @($frozenPaths | Select-Object -Unique)) {
        [pscustomobject]@{ path = [IO.Path]::GetFullPath($file); sha256 = Get-FileSha256 -Path $file }
    })
    Assert-KnowledgeContentSourceReceiptClosureFrozen -Bindings $receiptBindings -FrozenFiles $frozen
    Assert-StandardCoreFrozenFiles -Files $frozen
    Assert-StandardCoreSourceToolReceipts -Bindings $receiptBindings -FrozenFiles $frozen -RunId $setupId

    $dispatch = [ordered]@{
        packageAdapter = [ordered]@{ command = $PowerShell; arguments = @($arguments + @('-Mode', 'package-adapter')) }
        skillValidator = [ordered]@{ command = $PowerShell; arguments = @($arguments + @('-Mode', 'skill-validator')) }
        skillTools = [ordered]@{ command = $PowerShell; arguments = @($arguments + @('-Mode', 'skill-tools')) }
        staticAnalyzer = [ordered]@{ command = $PowerShell; arguments = @($arguments + @('-Mode', 'static')) }
        frozenFiles = $frozen
        toolReceipts = $receiptBindings
    }
    $prepared = [ordered]@{
        schemaVersion = 1
        preparation = 'knowledge-content-source-tools'
        runId = $setupId
        sourceRevision = $CandidateRevision
        authorityRevision = [string]$AuthorityPin.commit
        ownedRoot = $owned
        sourceValidation = $dispatch
    }
    Write-KnowledgeContentSourceSetupArtifact -Path $PreparedPath -Text (($prepared | ConvertTo-Json -Depth 40) + [Environment]::NewLine) -ProtectedToken $protectedToken
}

function Test-KnowledgeContentPathEqual {
    param(
        [Parameter(Mandatory = $true)][string] $Left,
        [Parameter(Mandatory = $true)][string] $Right
    )

    $comparison = if ($IsWindows) { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
    return [IO.Path]::GetFullPath($Left).Equals([IO.Path]::GetFullPath($Right), $comparison)
}

function Write-KnowledgeContentSourceTimingSidecar {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $Path,
        [Parameter(Mandatory = $true)][string[]] $OutputLines,
        [Parameter(Mandatory = $true)][string] $RunId,
        [Parameter(Mandatory = $true)][string] $SourceRevision,
        [Parameter(Mandatory = $true)][string] $BaseRevision,
        [Parameter(Mandatory = $true)][string] $AuthorityRevision,
        [switch] $RequireCoreEvidence
    )

    $records = [Collections.Generic.List[object]]::new()
    $prefix = '[StandardValidation timing] '
    foreach ($line in $OutputLines) {
        $text = [string]$line
        if (-not $text.StartsWith($prefix, [StringComparison]::Ordinal)) { continue }
        try { $record = ConvertFrom-Json -InputObject $text.Substring($prefix.Length) -Depth 5 -ErrorAction Stop }
        catch { throw 'Source validation emitted a malformed structured timing record.' }
        Assert-KnowledgeContentExactPropertySet -Value $record -Expected @('stage', 'phase', 'state', 'calls', 'files', 'bytes', 'elapsedSeconds') -Context 'Source validation timing record'
        if ([string]$record.stage -cnotmatch '^[A-Za-z0-9][A-Za-z0-9_.-]{0,63}$' -or
            [string]$record.phase -cnotmatch '^[A-Za-z0-9][A-Za-z0-9_.-]{0,63}$' -or
            [string]$record.state -cnotin @('started', 'heartbeat', 'completed', 'failed', 'cancelled')) {
            throw 'Source validation timing record has an invalid stage, phase, or state.'
        }
        $calls = [long]$record.calls
        $files = [long]$record.files
        $bytes = [long]$record.bytes
        $elapsed = [double]$record.elapsedSeconds
        if ($calls -lt 0 -or $files -lt 0 -or $bytes -lt 0 -or [double]::IsNaN($elapsed) -or [double]::IsInfinity($elapsed) -or $elapsed -lt 0) {
            throw 'Source validation timing record has an invalid counter or duration.'
        }
        $records.Add([pscustomobject][ordered]@{
            stage = [string]$record.stage
            phase = [string]$record.phase
            state = [string]$record.state
            calls = $calls
            files = $files
            bytes = $bytes
            elapsedSeconds = $elapsed
        })
    }

    if ($RequireCoreEvidence) {
        foreach ($phase in @('candidate-inventory', 'file-inventory', 'inventory-sort', 'closure-content-hash')) {
            if (@($records | Where-Object { [string]$_.phase -ceq $phase -and [string]$_.state -ceq 'completed' }).Count -eq 0) {
                throw "Successful source validation omitted completed '$phase' timing evidence."
            }
        }
    }

    $sidecar = [ordered]@{
        schemaVersion = 1
        report = 'standard-core-source-timing-v1'
        runId = $RunId
        sourceRevision = $SourceRevision
        baseRevision = $BaseRevision
        authorityRevision = $AuthorityRevision
        records = @($records.ToArray())
    }
    Write-KnowledgeContentUtf8CreateNew -Path $Path -Text (($sidecar | ConvertTo-Json -Depth 10) + [Environment]::NewLine)
    return [IO.Path]::GetFullPath($Path)
}

function Read-KnowledgeContentSourceToolSetup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $Path,
        [Parameter(Mandatory = $true)][string] $SourceRevision,
        [Parameter(Mandatory = $true)][string] $AuthorityRevision,
        [Parameter(Mandatory = $true)][string] $PowerShell,
        [Parameter(Mandatory = $true)][string] $AuthorityRoot
    )

    $fullPath = [IO.Path]::GetFullPath($Path)
    $authorityRunner = Join-Path $AuthorityRoot 'scripts/Invoke-StandardValidation.ps1'
    . $authorityRunner -DefineFunctionsOnly -CandidateRoot $AuthorityRoot -AdapterPath $fullPath -ArtifactsRoot (Split-Path -Parent $fullPath) -SourceRepository $script:SourceRepository -SourceRevision $SourceRevision -BaseRevision $SourceRevision -AuthorityRevision $AuthorityRevision
    Assert-NoReparseAncestors -Path $fullPath -Context 'Prepared source setup'
    $prepared = Read-JsonFile -Path $fullPath -Context 'Prepared source setup'
    Assert-KnowledgeContentExactPropertySet -Value $prepared -Expected @('schemaVersion', 'preparation', 'runId', 'sourceRevision', 'authorityRevision', 'ownedRoot', 'sourceValidation') -Context 'Prepared source setup'
    if ([int]$prepared.schemaVersion -ne 1 -or
        [string]$prepared.preparation -cne 'knowledge-content-source-tools' -or
        [string]$prepared.runId -cnotmatch '^[0-9a-f]{32}$' -or
        [string]$prepared.sourceRevision -cne $SourceRevision -or
        [string]$prepared.authorityRevision -cne $AuthorityRevision) {
        throw 'Prepared source tools do not bind this candidate and authority.'
    }
    Assert-KnowledgeContentExactPropertySet -Value $prepared.sourceValidation -Expected @('packageAdapter', 'skillValidator', 'skillTools', 'staticAnalyzer', 'frozenFiles', 'toolReceipts') -Context 'Prepared source dispatch'
    foreach ($slot in @('packageAdapter', 'skillValidator', 'skillTools', 'staticAnalyzer')) {
        Assert-KnowledgeContentExactPropertySet -Value $prepared.sourceValidation.$slot -Expected @('command', 'arguments') -Context "Prepared source dispatch $slot"
        if ([string]$prepared.sourceValidation.$slot.command -cne $PowerShell) {
            throw "Prepared source dispatch $slot does not use the verified PowerShell runtime."
        }
    }
    $expectedOwned = Join-Path (Split-Path -Parent $fullPath) "source-tools-$($prepared.runId)"
    if (-not (Test-KnowledgeContentPathEqual -Left ([string]$prepared.ownedRoot) -Right $expectedOwned)) {
        throw 'Prepared source setup owned root differs.'
    }
    Assert-NoReparseAncestors -Path $expectedOwned -Context 'Prepared source setup owned root'
    $wrapper = Join-Path $expectedOwned 'Invoke-KnowledgeContentValidationChild.ps1'
    $wrapperHash = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($childRunnerText))).ToLowerInvariant()
    if ((Get-FileSha256 -Path $wrapper) -cne $wrapperHash) { throw 'Prepared source wrapper differs from the protected driver.' }
    $toolchain = Join-Path $expectedOwned 'toolchain.json'
    Assert-StandardCoreFrozenFiles -Files @($prepared.sourceValidation.frozenFiles)
    Assert-StandardCoreSourceToolReceipts -Bindings @($prepared.sourceValidation.toolReceipts) -FrozenFiles @($prepared.sourceValidation.frozenFiles) -RunId ([string]$prepared.runId)

    $receipts = @{}
    foreach ($receiptBinding in @($prepared.sourceValidation.toolReceipts)) {
        $receipt = Read-JsonFile -Path ([string]$receiptBinding.path) -Context 'Prepared source resolver receipt'
        $receipts[[string]$receipt.toolName] = $receipt
    }
    $preparedToolchain = Read-JsonFile -Path $toolchain -Context 'Prepared source toolchain'
    Assert-KnowledgeContentExactPropertySet -Value $preparedToolchain -Expected @('centralRunnerPath', 'centralRunnerSha256', 'upstreamAdapterValidatorPath', 'upstreamAdapterValidatorSha256', 'upstreamPolicyPath', 'upstreamPolicySha256', 'skillValidatorPath', 'skillValidatorSha256', 'skillToolsNodePath', 'skillToolsNodeSha256', 'skillToolsEntryPointPath', 'skillToolsEntryPointSha256', 'skillSpectorPath', 'skillSpectorSha256', 'skillSpectorReceiptPath', 'skillSpectorReceiptSha256') -Context 'Prepared source toolchain'
    foreach ($authorityBinding in @(
        @('centralRunnerPath', 'centralRunnerSha256', 'scripts/Invoke-StandardValidation.ps1'),
        @('upstreamAdapterValidatorPath', 'upstreamAdapterValidatorSha256', 'scripts/Validate-UpstreamAdapter.ps1'),
        @('upstreamPolicyPath', 'upstreamPolicySha256', 'docs/standards/upstream-adapter.json')
    )) {
        $expectedAuthorityFile = [IO.Path]::GetFullPath((Join-Path $AuthorityRoot $authorityBinding[2]))
        if (-not (Test-KnowledgeContentPathEqual -Left ([string]$preparedToolchain.($authorityBinding[0])) -Right $expectedAuthorityFile) -or
            [string]$preparedToolchain.($authorityBinding[1]) -cne (Get-FileSha256 -Path $expectedAuthorityFile)) {
            throw 'Prepared source toolchain differs from the verified authority files.'
        }
    }
    foreach ($binding in @(
        @{ actualPath = $preparedToolchain.skillValidatorPath; actualSha = $preparedToolchain.skillValidatorSha256; expectedPath = $receipts.'skill-validator'.executablePath; expectedSha = $receipts.'skill-validator'.executableSha256; name = 'skill-validator' },
        @{ actualPath = $preparedToolchain.skillToolsNodePath; actualSha = $preparedToolchain.skillToolsNodeSha256; expectedPath = $receipts.'skill-tools'.nodePath; expectedSha = $receipts.'skill-tools'.nodeSha256; name = 'skill-tools Node' },
        @{ actualPath = $preparedToolchain.skillToolsEntryPointPath; actualSha = $preparedToolchain.skillToolsEntryPointSha256; expectedPath = $receipts.'skill-tools'.entryPointPath; expectedSha = $receipts.'skill-tools'.entryPointSha256; name = 'skill-tools entry point' },
        @{ actualPath = $preparedToolchain.skillSpectorPath; actualSha = $preparedToolchain.skillSpectorSha256; expectedPath = $receipts.skillspector.executablePath; expectedSha = $receipts.skillspector.executableSha256; name = 'skillspector' }
    )) {
        if ([string]$binding.actualPath -cne [string]$binding.expectedPath -or [string]$binding.actualSha -cne [string]$binding.expectedSha) {
            throw "Prepared source toolchain does not match the $($binding.name) resolver receipt."
        }
    }
    $staticReceipt = @($prepared.sourceValidation.toolReceipts | Where-Object { [string]$_.path -ceq [string]$preparedToolchain.skillSpectorReceiptPath })
    if ($staticReceipt.Count -ne 1 -or
        [string]$staticReceipt[0].sha256 -cne [string]$preparedToolchain.skillSpectorReceiptSha256 -or
        (Read-JsonFile -Path ([string]$staticReceipt[0].path) -Context 'Prepared Static receipt').toolName -cne 'skillspector') {
        throw 'Prepared source Static receipt differs.'
    }

    $archive = Join-Path $expectedOwned 'candidate.zip'
    $arguments = @('-NoProfile', '-NonInteractive', '-File', $wrapper, '-ToolchainPath', $toolchain, '-ToolchainSha256', (Get-FileSha256 -Path $toolchain), '-SourceRepository', $script:SourceRepository, '-SourceRevision', $SourceRevision, '-ArchiveSha256', (Get-FileSha256 -Path $archive))
    foreach ($entry in @(
        @('packageAdapter', 'package-adapter'),
        @('skillValidator', 'skill-validator'),
        @('skillTools', 'skill-tools'),
        @('staticAnalyzer', 'static')
    )) {
        $command = $prepared.sourceValidation.($entry[0])
        $expectedArguments = @($arguments + @('-Mode', $entry[1]))
        if ((ConvertTo-Json -InputObject @($command.arguments) -Compress) -cne (ConvertTo-Json -InputObject $expectedArguments -Compress)) {
            throw 'Prepared source dispatch differs from the protected driver.'
        }
    }
    return $prepared
}

function Get-KnowledgeContentSourceResolverEnvironment {
    [CmdletBinding()]
    param([switch] $IncludeSetupToken)

    $environment = @{}
    if ($IncludeSetupToken) {
        $sourceSetupGitHubToken = [Environment]::GetEnvironmentVariable('KC_SOURCE_SETUP_GITHUB_TOKEN', 'Process')
        if (-not [string]::IsNullOrWhiteSpace($sourceSetupGitHubToken)) {
            $environment['STANDARD_VALIDATION_GITHUB_API_TOKEN'] = $sourceSetupGitHubToken
        }
    }
    Remove-Item -LiteralPath 'Env:KC_SOURCE_SETUP_GITHUB_TOKEN', 'Env:GITHUB_TOKEN', 'Env:GH_TOKEN' -Force -ErrorAction SilentlyContinue
    return $environment
}

function Invoke-KnowledgeContentSourcePurpose {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][ValidateSet('prepare-source-tools', 'source-validation')][string] $Mode,
        [Parameter(Mandatory = $true)][string] $RepositoryRoot,
        [Parameter(Mandatory = $true)][string] $ArtifactsRoot,
        [Parameter(Mandatory = $true)][string] $SourceToolsPath,
        [Parameter(Mandatory = $true)][string] $AuthorityRepositoryRoot,
        [Parameter(Mandatory = $true)][string] $TrustedToolRoot,
        [Parameter(Mandatory = $true)] $AuthorityPin,
        $CandidateAuthority,
        [string] $BaseCommit,
        [string] $ExpectedGoRuntimeVersion,
        [string] $OutputPath,
        [int] $TimeoutSeconds = 900
    )

    $resolverEnvironment = Get-KnowledgeContentSourceResolverEnvironment -IncludeSetupToken:($Mode -ceq 'prepare-source-tools')

    $repoRoot = [IO.Path]::GetFullPath($RepositoryRoot)
    if (-not (Test-Path -LiteralPath $repoRoot -PathType Container)) { throw "RepositoryRoot does not exist: $repoRoot" }
    $gitPath = Get-ResolvedGitPath
    $pwshPath = Get-ResolvedPowerShellPath
    $candidateCommit = Resolve-GitRevision -GitPath $gitPath -Root $repoRoot -Revision 'HEAD' -Context 'Candidate revision'
    $dirty = @(& $gitPath -C $repoRoot status --porcelain=v1 --untracked-files=all)
    if ($LASTEXITCODE -ne 0 -or $dirty.Count -ne 0) { throw 'Explicit source purposes require a clean immutable candidate commit.' }

    if ($Mode -ceq 'source-validation') {
        [void](Assert-KnowledgeContentPreparedAuthorityTuple -Authority $CandidateAuthority)
        if ([string]$CandidateAuthority.commit -cne [string]$AuthorityPin.commit) { throw 'Source validation candidate authority differs from the prepared authority.' }
        if ([string]::IsNullOrWhiteSpace($BaseCommit)) { $BaseCommit = 'HEAD^' }
        $baseRevision = Resolve-GitRevision -GitPath $gitPath -Root $repoRoot -Revision $BaseCommit -Context 'Base commit'
        & $gitPath -C $repoRoot merge-base --is-ancestor $baseRevision $candidateCommit
        if ($LASTEXITCODE -ne 0 -or $baseRevision -ceq $candidateCommit) { throw 'Base commit must be a distinct ancestor of the immutable source candidate.' }
    }

    $authorityCheckout = Assert-KnowledgeContentPreparedAuthorityCheckout -GitPath $gitPath -AuthorityRoot $AuthorityRepositoryRoot -AuthorityPin $AuthorityPin
    $trustedRoot = [IO.Path]::GetFullPath($TrustedToolRoot)
    if (-not (Test-Path -LiteralPath $trustedRoot -PathType Container)) { throw "Trusted PowerShell root is missing: $trustedRoot" }
    Assert-NoReparseAncestors -Path $trustedRoot -Context 'Trusted PowerShell root'
    $comparison = if ($IsWindows) { [StringComparison]::OrdinalIgnoreCase } else { [StringComparison]::Ordinal }
    if (-not (Test-KnowledgeContentPathEqual -Left $pwshPath -Right $trustedRoot) -and
        -not $pwshPath.StartsWith($trustedRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar, $comparison)) {
        throw 'Trusted PowerShell executable must be within TrustedToolRoot.'
    }

    $artifactsRootFull = [IO.Path]::GetFullPath($ArtifactsRoot)
    Assert-OutsideRoot -Path $artifactsRootFull -Root $repoRoot -Context 'Source artifacts root'
    Assert-OutsideRoot -Path $artifactsRootFull -Root $authorityCheckout.root -Context 'Source artifacts root'
    Assert-OutsideRoot -Path $artifactsRootFull -Root $trustedRoot -Context 'Source artifacts root'
    [void](New-Item -ItemType Directory -Path $artifactsRootFull -Force)
    Assert-NoReparseAncestors -Path $artifactsRootFull -Context 'Source artifacts root'

    if ($Mode -ceq 'prepare-source-tools') {
        $preparedPath = Assert-PathWithinRoot -Path $SourceToolsPath -Root $artifactsRootFull -Context 'Source tools output'
        if (-not (Test-KnowledgeContentPathEqual -Left (Split-Path -Parent $preparedPath) -Right $artifactsRootFull)) {
            throw 'Source tools output must be directly within ArtifactsRoot.'
        }
        if (Test-Path -LiteralPath $preparedPath) { throw 'Source tools output already exists.' }
        $goVersion = Resolve-GoRuntimeVersion -Expected $ExpectedGoRuntimeVersion
        New-KnowledgeContentSourceToolSetup -Root $artifactsRootFull -AuthorityRoot $authorityCheckout.root -AuthorityPin $AuthorityPin `
            -PowerShell $pwshPath -CandidateRevision $candidateCommit -Git $gitPath -SourceCheckoutRoot $repoRoot `
            -PreparedPath $preparedPath -GoVersion $goVersion -LimitSeconds $TimeoutSeconds -ResolverEnvironment $resolverEnvironment
        return 0
    }

    $preparedPath = [IO.Path]::GetFullPath($SourceToolsPath)
    Assert-OutsideRoot -Path $preparedPath -Root $repoRoot -Context 'Source tools input'
    Assert-OutsideRoot -Path $preparedPath -Root $authorityCheckout.root -Context 'Source tools input'
    Assert-OutsideRoot -Path $preparedPath -Root $trustedRoot -Context 'Source tools input'
    $prepared = Read-KnowledgeContentSourceToolSetup -Path $preparedPath -SourceRevision $candidateCommit -AuthorityRevision ([string]$AuthorityPin.commit) -PowerShell $pwshPath -AuthorityRoot $authorityCheckout.root
    $eventName = Get-EventName
    $activeSkills = @(Get-ActiveSkillIds -Root $repoRoot)
    $runId = [string]$prepared.runId
    $coreArtifactsRoot = Join-Path $artifactsRootFull "source-validation-$runId"
    $adapterLayout = Get-KnowledgeContentCorePesterLayout -ArtifactsRoot $artifactsRootFull -RunId $runId
    $adapterRoot = [string]$adapterLayout.adapterRoot
    if ((Test-Path -LiteralPath $coreArtifactsRoot) -or (Test-Path -LiteralPath $adapterRoot)) { throw 'Source validation run-owned path unexpectedly exists.' }
    [void](New-Item -ItemType Directory -Path $coreArtifactsRoot -ErrorAction Stop)
    Assert-NoReparseAncestors -Path $coreArtifactsRoot -Context 'Source validation artifacts root'
    $outputFull = if ([string]::IsNullOrWhiteSpace($OutputPath)) {
        Join-Path $coreArtifactsRoot 'knowledge-content-source-validation.json'
    }
    else { Assert-PathWithinRoot -Path $OutputPath -Root $coreArtifactsRoot -Context 'Source validation OutputPath' }
    if (Test-Path -LiteralPath $outputFull) { throw 'Source validation output path is not create-only.' }
    $adapterRoot = Assert-PathWithinRoot -Path $adapterRoot -Root $artifactsRootFull -Context 'Core Pester adapter root'
    $adapterOwned = $false
    $adapterOwnerToken = [guid]::NewGuid().ToString('N')
    try {
        [void](New-Item -ItemType Directory -Path $adapterRoot -ErrorAction Stop)
        $adapterOwned = $true
        Assert-NoReparseAncestors -Path $adapterRoot -Context 'Core Pester adapter root'
        Assert-OutsideRoot -Path $adapterRoot -Root $repoRoot -Context 'Core Pester adapter root'
        Assert-OutsideRoot -Path $adapterRoot -Root $authorityCheckout.root -Context 'Core Pester adapter root'
        Assert-OutsideRoot -Path $adapterRoot -Root $trustedRoot -Context 'Core Pester adapter root'
        Assert-OutsideRoot -Path $adapterRoot -Root $coreArtifactsRoot -Context 'Core Pester adapter root'
        $ownerMarker = [ordered]@{ owner = 'knowledge-content-source-core-adapter'; runId = $runId; token = $adapterOwnerToken }
        Write-KnowledgeContentUtf8CreateNew -Path ([string]$adapterLayout.ownerMarkerPath) -Text (($ownerMarker | ConvertTo-Json -Compress) + [Environment]::NewLine)

        $adapterPath = [string]$adapterLayout.adapterPath
        $adapter = New-KnowledgeContentSourceCoreAdapter -PowerShell $pwshPath -RunId $runId -ActiveSkillIds $activeSkills -SourceValidation $prepared.sourceValidation
        Write-KnowledgeContentUtf8CreateNew -Path $adapterPath -Text (($adapter | ConvertTo-Json -Depth 30) + [Environment]::NewLine)
        $authoritySnapshot = New-KnowledgeContentCoreAuthoritySnapshot -GitPath $gitPath -SourceRoot $authorityCheckout.root -OwnedRoot $adapterRoot -AuthorityPin $AuthorityPin

        $centralRunnerPath = [string]$authoritySnapshot.runnerPath
        . $centralRunnerPath -DefineFunctionsOnly -CandidateRoot $repoRoot -AdapterPath $adapterPath -ArtifactsRoot $coreArtifactsRoot `
            -SourceRepository $script:SourceRepository -SourceRevision $candidateCommit -BaseRevision $baseRevision `
            -AuthorityRevision ([string]$AuthorityPin.commit) -RunId $runId -EventName $eventName -TimeoutSeconds $TimeoutSeconds
        $validationSecurityPolicy = Read-JsonFile -Path (Join-Path $authoritySnapshot.root 'docs/standards/validation-security-gate.json') `
            -Context 'Prepared authority validation security policy'
        $skillSpectorStages = @($validationSecurityPolicy.stages | Where-Object { [string]$_.id -ceq 'skillspector-static' })
        if ($skillSpectorStages.Count -ne 1 -or $null -eq $skillSpectorStages[0].platformUnavailableException) {
            throw 'Prepared authority validation security policy has no unique SkillSpector platform exception contract.'
        }
        $skillSpectorPlatformPolicy = $skillSpectorStages[0].platformUnavailableException
        $arguments = @(
            '-CandidateRoot', $repoRoot,
            '-AdapterPath', $adapterPath,
            '-ArtifactsRoot', $coreArtifactsRoot,
            '-OutputPath', $outputFull,
            '-SourceRepository', $script:SourceRepository,
            '-SourceRevision', $candidateCommit,
            '-BaseRevision', $baseRevision,
            '-EventName', $eventName,
            '-AuthorityRevision', [string]$AuthorityPin.commit,
            '-TimeoutSeconds', [string]$TimeoutSeconds,
            '-TrustedToolRoot', $trustedRoot,
            '-SourceValidation',
            '-RunId', $runId
        )
        $centralOutput = @(& $pwshPath -NoProfile -NonInteractive -File $centralRunnerPath @arguments 2>&1)
        $centralExitCode = $LASTEXITCODE
        $centralOutput | Out-Host
        $timingSidecarPath = Join-Path $artifactsRootFull "source-validation-timing-$runId.json"
        [void](Write-KnowledgeContentSourceTimingSidecar -Path $timingSidecarPath -OutputLines @($centralOutput | ForEach-Object { [string]$_ }) `
            -RunId $runId -SourceRevision $candidateCommit -BaseRevision $baseRevision -AuthorityRevision ([string]$AuthorityPin.commit) `
            -RequireCoreEvidence:($centralExitCode -eq 0))
        Write-Host "Source validation timing sidecar: $timingSidecarPath"
        if ($centralExitCode -ne 0) { return [int]$centralExitCode }
        if (-not (Test-Path -LiteralPath $outputFull -PathType Leaf)) { throw 'Source validation did not write its canonical report.' }
        $reportHashBeforeProjection = Get-FileSha256 -Path $outputFull
        $report = Read-JsonFile -Path $outputFull -Context 'Source validation report projection'
        [void](Assert-StandardCoreSourceCheckReport -Report $report -ExpectedSourceRevision $candidateCommit -ExpectedBaseRevision $baseRevision `
            -ExpectedAuthorityRevision ([string]$AuthorityPin.commit) -ExpectedEventName $eventName -ArtifactsRoot $coreArtifactsRoot `
            -OutputPath $outputFull -ProcessExitCode $centralExitCode -ValidationSecurityPolicy $skillSpectorPlatformPolicy)
        if ((Get-FileSha256 -Path $outputFull) -cne $reportHashBeforeProjection) { throw 'Source validation report bytes changed during final projection.' }
        return 0
    }
    finally {
        if ($adapterOwned) {
            Remove-KnowledgeContentOwnedCoreAdapterRoot -OwnedRoot $adapterRoot -ArtifactsRoot $artifactsRootFull -RunId $runId `
                -OwnerToken $adapterOwnerToken -RepositoryRoot $repoRoot -AuthorityRoot $authorityCheckout.root `
                -TrustedToolRoot $trustedRoot -CoreArtifactsRoot $coreArtifactsRoot
        }
    }
}
