let rdkitInstance: any = null;

export const getRDKit = async () => {
  if (rdkitInstance) return rdkitInstance

  const script = document.createElement("script");
  script.src = "https://unpkg.com/@rdkit/rdkit/dist/RDKit_minimal.js";
  script.async = true;
  document.head.appendChild(script);

  return await new Promise((resolve) => {
    script.onload = async () => {
      // @ts-ignore: window.initRDKitModule is injected by the script
      const RDKit = await globalThis.initRDKitModule();
      rdkitInstance = RDKit;
      resolve(RDKit);
    };
  });
};
