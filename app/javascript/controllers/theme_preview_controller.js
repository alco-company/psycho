import { Controller } from "@hotwired/stimulus"

// Live preview for Theme form. Validates presence of {{yield}} and renders a preview in an iframe.
export default class extends Controller {
  static targets = ["frame", "html", "css", "js", "warning", "submit"]
  static values = { sample: String }

  connect() {
    this.changed()
  }

  changed() {
    const htmlLayout = this.hasHtmlTarget ? this.htmlTarget.value || "" : ""
    const css = this.hasCssTarget ? this.cssTarget.value || "" : ""
    const js = this.hasJsTarget ? this.jsTarget.value || "" : ""

    const hasYield = htmlLayout.includes("{{yield}}")
    if (this.hasWarningTarget) {
      this.warningTarget.classList.toggle("hidden", hasYield)
    }
    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = !hasYield
      this.submitTarget.title = hasYield ? "" : "Add {{yield}} to enable saving"
    }

    // Build preview HTML by replacing {{yield}} with sample content
    const sample = this.hasSampleValue && this.sampleValue ? this.sampleValue : "<h1>Preview</h1><p>Sample content rendered at {{yield}}.</p>"
    let html = htmlLayout.replaceAll("{{yield}}", sample)

    // Inject CSS before </head>, or prepend if no head present
    if (css && css.trim().length > 0) {
      const styleTag = `<style>${css}</style>`
      if (html.includes("</head>")) {
        html = html.replace("</head>", `${styleTag}</head>`)
      } else {
        html = `<!doctype html><html><head>${styleTag}</head><body>${html}</body></html>`
      }
    }

    // Inject JS before </body>, or append if no body present
    if (js && js.trim().length > 0) {
      const scriptTag = `<script>(function(){${js}})();<\/script>`
      if (html.includes("</body>")) {
        html = html.replace("</body>", `${scriptTag}</body>`)
      } else {
        html = `${html}${scriptTag}`
      }
    }

    // If result has no html/body, wrap it for consistent preview
    if (!/\<html[\s\S]*\>/i.test(html)) {
      html = `<!doctype html><html><head><meta charset=\"utf-8\"></head><body>${html}</body></html>`
    }

    if (this.hasFrameTarget) {
      this.frameTarget.srcdoc = html
    }
  }
}
