import { apiClient } from "./api.ts";

export const fetchChemicalDetails = async (id: string) => {
  try {
    const data = await apiClient(`chemical_lookup?id=${id}`)
    if (!data) throw new Error(`No data found for solvent ID: ${id}`)
    return data
  } catch (error) {
    console.error("API error in fetchChemicalDetails:", error)
    throw error
  }
}