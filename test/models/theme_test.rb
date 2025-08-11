require "test_helper"

class ThemeTest < ActiveSupport::TestCase
  test "defaults name when blank and requires tenant" do
    t = Theme.new
    assert_not t.valid?
    assert_equal "Default Theme", t.name
    assert_includes t.errors[:tenant], "must exist"
  end

  test "enqueues build on css change" do
    theme = themes(:acme_theme)
    assert_enqueued_with(job: TailwindBuildJob) do
      theme.update!(css: theme.css.to_s + "\n/* tweak */")
    end
  end

  test "enqueues build on js change" do
    theme = themes(:acme_theme)
    assert_enqueued_with(job: TailwindBuildJob) do
      theme.update!(js: theme.js.to_s + "\n// tweak")
    end
  end

  test "enqueues build on html_layout change" do
    theme = themes(:acme_theme)
    assert_enqueued_with(job: TailwindBuildJob) do
      theme.update!(html_layout: theme.html_layout.to_s + "\n<div class='text-lg'></div>")
    end
  end
end
