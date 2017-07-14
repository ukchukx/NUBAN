defmodule NUBAN do
  def valid?(bank_code, account_number) do
    valid?(String.trim(bank_code) <> String.trim(account_number))
  end
  
  def valid?(account_number) do
    case String.length(account_number) do
      13 -> do_valid?(account_number)
      _ -> false
    end
  end

  defp do_valid?(account_number) do
    {sum, check_digit} =
      account_number
      |> String.split("", trim: true)
      |> Stream.map(fn x -> Integer.parse(x) |> elem(0) end)
      |> Stream.with_index
      |> Stream.map(fn
        {num, idx} when idx in [1, 4, 7, 10] -> {num * 7, idx}
        {num, 12} -> {num, 12}
        {num, idx} -> {num * 3, idx}
      end)
     |> Enum.to_list
     |> Enum.reduce({0, 0}, fn 
        {num, 12}, {sum, _} -> {sum, num}
        {num, x}, {sum, _} -> {sum + num, x}    
     end)

    case rem(sum, 10) do
      x when (10 - check_digit) == x -> true
      0 -> check_digit == 0
      _ -> false
    end
  end
end