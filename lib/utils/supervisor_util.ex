defmodule SupervisorUtil do
  @moduledoc """
  Supervisor helper functions.
  """

  @spec find_child_by_child_id(pid(), String.t()) :: pid() | nil
  def find_child_by_child_id(supervisor_id, child_id) do
    child =
      Enum.find(
        Supervisor.which_children(supervisor_id),
        fn {id, _, _, _} ->
          id == child_id
        end
      )

    case child do
      nil -> nil
      {_, pid, _, _} -> pid
    end
  end
end
