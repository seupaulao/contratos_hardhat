import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("LivroDatabaseModule", (m) => {
  const livroDatabase = m.contract("LivroDatabase");

  return { livroDatabase };
});