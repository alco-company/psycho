import { Controller } from "@hotwired/stimulus"

// Filters the Theme dropdown to only show themes for the selected tenant
export default class extends Controller {
  static targets = ["tenantSelect", "themeSelect"]
  static values = { themes: Object }

  connect() {
    this.updateThemes()
  }

  tenantChanged() {
    // Clear current selection when tenant changes
    if (this.hasThemeSelectTarget) {
      this.themeSelectTarget.selectedIndex = -1
    }
    this.updateThemes()
  }

  updateThemes() {
    if (!this.hasTenantSelectTarget || !this.hasThemeSelectTarget) return

    const tenantId = this.tenantSelectTarget.value
    const themesByTenant = this.themesValue || {}
    const items = themesByTenant[tenantId] || []

    // Preserve current selection if still available
    const current = this.themeSelectTarget.value

    // Reset options
    this.themeSelectTarget.innerHTML = ""

    // Add blank option
    const blank = document.createElement("option")
    blank.value = ""
    blank.textContent = "-- default (tenant/app) --"
    this.themeSelectTarget.appendChild(blank)

    // Populate options
    for (const t of items) {
      const opt = document.createElement("option")
      opt.value = String(t.id)
      opt.textContent = t.name
      if (current && current === String(t.id)) opt.selected = true
      this.themeSelectTarget.appendChild(opt)
    }
  }
}
