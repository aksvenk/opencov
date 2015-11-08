defmodule Opencov.BadgeTest do
  use Opencov.ModelCase

  alias Opencov.Badge

  @format :svg

  @project_attrs %{name: "some content", base_url: "https://github.com/tuvistavie/opencov", current_coverage: 58.4}

  setup do
    project = Opencov.Repo.insert! Opencov.Project.changeset(%Opencov.Project{}, @project_attrs)
    {:ok, project: project}
  end

  test "get_or_create when no badge exist", %{project: project} do
    {:ok, badge} = Badge.get_or_create(project, @format)
    assert badge.id
    assert badge.coverage == project.current_coverage
  end

  test "get_or_create when badge exists", %{project: project} do
    {:ok, badge} = Badge.get_or_create(project, @format)
    assert badge.id

    {:ok, new_badge} = Badge.get_or_create(project, @format)
    assert badge.id == new_badge.id
  end

  test "get_or_create when badge exists and coverage changed", %{project: project} do
    {:ok, badge} = Badge.get_or_create(project, @format)
    assert badge.id

    new_coverage = 62.4
    project = Opencov.Repo.update!(%{project | current_coverage: new_coverage})

    {:ok, new_badge} = Badge.get_or_create(project, @format)
    assert badge.id == new_badge.id
    assert new_badge.coverage == new_coverage
  end
end