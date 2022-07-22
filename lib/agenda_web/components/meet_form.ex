defmodule AgendaWeb.Components.MeetForm do
  @moduledoc """
  A sample component to build the Meet Form and schedule it.
  """
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, TextInput, Label, Select, TextArea, Checkbox}
  alias Agenda.{Schedule, Dates}
  alias Agenda.Schedule.Meeting

  # use Surface.Components
  data changeset, :changeset, default: Schedule.change_meeting(%Meeting{})
  data data, :any, default: ""
  data error, :boolean, default: false
  data insert_state, :boolean, default: false
  data strict_mode, :boolean, default: false

  def render(assigns) do
    ~F"""
    <div>
      <div :if={@insert_state} class="notification is-success">
        <p>
          Succes you just add it !!</p>
      </div>
      <div :if={@error} class="notification is-danger">
        <p>
          Error! Verify your inputs
        </p>
      </div>
      <div>
        <Field name={:mode}>
          <Label class="label" />
          {#if @strict_mode == false}
            Schedule Strict Mode <Checkbox click="db_config" value="false" values={state: "false"} id="strict_mode" /> <br>
          {#else}
            Schedule Strict Mode <Checkbox click="db_config" value="true" values={state: "true"} id="strict_mode" /> <br>
          {/if}
        </Field>
      </div>
      <Form for={@changeset} submit="save">
        <Field name={:title}>
          <Label class="label" />
          <div class="control">
            <TextInput class="input is-info" opts={placeholder: "title"} />
          </div>
        </Field>
        <Field name={:description}>
          <Label class="label" />
          <div class="control">
            <TextArea class="textarea is-info" rows="4" opts={placeholder: "4 lines of textarea"} />
          </div>
        </Field>
        <Field name={:week}>
          <Label class="label" />
          <div class="select">
            <Select options={First: "first", Second: "second", Third: "third", fourth: "fourth", fifth: "fifth"} />
          </div>
        </Field>
        <Field name={:day}>
          <Label class="label" />
          <div class="select">
            <Select options={
              monday: "monday",
              tuesday: "tuesday",
              wednesday: "wednesday",
              thursday: "thursday",
              friday: "friday",
              saturday: "saturday",
              sunday: "sunday"
            } />
          </div>
        </Field>
        <Field name={:month}>
          <Label class="label" />
          <div class="select">
            <Select options={
              january: "january",
              february: "february",
              march: "march",
              april: "april",
              may: "may",
              june: "june",
              july: "july",
              august: "august",
              september: "september",
              october: "october",
              november: "november",
              december: "december"
            } />
          </div>
        </Field>
        <Field name={:year}>
          <Label class="label" />
          <div class="select">
            <Select options={"2022": "2022", "2023": "2023", "2024": "2024", "2025": "2025", "2026": "2026"} />
          </div>
        </Field>
        <div class="save-form">
          <button class="button is-link" type="submit" id="add_data">Save</button>
        </div>
        <div class="column">
        </div>
      </Form>
    </div>
    """
  end

  def handle_event("db_config", _, socket) do
    strict_mode = change_state(socket.assigns.strict_mode)
    strict_mode |> IO.puts()
    {:noreply, assign(socket, strict_mode: strict_mode)}
  end

  def handle_event("save", %{"meeting" => meeting_params}, socket) do
    case socket.assigns.strict_mode do
      false -> insert_meeting(meeting_params, socket)
      true -> insert_meeting_strict(meeting_params, socket)
    end
  end

  defp insert_meeting(meeting_params, socket) do
    year = meeting_params["year"] |> String.to_atom()
    month = meeting_params["month"] |> String.to_atom()
    weekday = meeting_params["day"]
    week = meeting_params["week"] |> String.to_atom()

    if Schedule.validate_date(year, month, weekday, week) == false do
      insert_state = false
      error = true
      {:noreply, assign(socket, error: error, insert_state: insert_state)}
    else
      case Schedule.create_meeting(meeting_params) do
        {:ok, _} ->
          insert_state = true
          error = false
          {:noreply, assign(socket, insert_state: insert_state, error: error)}

        {:error, %Ecto.Changeset{}} ->
          insert_state = false
          error = true
          {:noreply, assign(socket, error: error, insert_state: insert_state)}
      end
    end
  end

  defp insert_meeting_strict(meeting_params, socket) do
    year = meeting_params["year"] |> String.to_atom()
    month = meeting_params["month"] |> String.to_atom()
    weekday = meeting_params["day"]
    week = meeting_params["week"] |> String.to_atom()
    date = Dates.merge_date(year, month, weekday, week)
    lenght_date = Schedule.day_meetings(date) |> length

    cond do
      lenght_date > 0 ->
        insert_state = false
        error = true
        {:noreply, assign(socket, error: error, insert_state: insert_state)}

      lenght_date == 0 ->
        insert_meeting(meeting_params, socket)
    end
  end

  defp change_state(state) do
    cond do
      state == true -> false
      state == false -> true
    end
  end
end
