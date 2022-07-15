defmodule Agenda.Dates do
  @moduledoc """
  The Date Module transforms the input
  to a Date type 
  """
  def merge_date(year, month, weekday, :first), do: find_date(year, month, weekday, 1..7)
  def merge_date(year, month, weekday, :second), do: find_date(year, month, weekday, 8..14)
  def merge_date(year, month, weekday, :third), do: find_date(year, month, weekday, 15..21)
  def merge_date(year, month, weekday, :fourth), do: find_date(year, month, weekday, 22..28)
  def merge_date(year, month, weekday, :fifth), do: find_date(year, month, weekday, 28..35)

  defp find_date(year, month, weekday, week_range) do
    try do
      year = Atom.to_string(year) |> String.to_integer()
      month = get_month_number(month)
      weekday_num = get_weekday_num(weekday)
  
      day_number =
        Enum.find(week_range, fn day ->
          case Date.new(year, month, day) do
            {:ok, date} ->
               weekday_num == Date.day_of_week(date)
            _invalid_date -> false
          end
        end)
  
      Date.new!(year, month, day_number)
    rescue
      FunctionClauseError -> :error_date_dont_exist
      _ -> "erro en fecha"
    end   
 
  end

  defp get_weekday_num(weekday) do
    Timex.day_to_num(weekday)
  end

  defp get_month_number(month) do
    Atom.to_string(month) |> Timex.month_to_num()
  end
end
