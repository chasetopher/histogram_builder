module HistogramBuilder
  class BarGraph

    # takes an Array of Arrays of names and milliseconds
    # ex. [["foo", 5], ["bar", 20], ...]
    # :scale option determines how many ms a single "#" symbol represents
    def initialize(names_and_time_ms, options = {})
      @names_and_time_ms = names_and_time_ms
      @order = :desc # default descending
      if options[:order] && %i(asc desc).include?(options[:order].to_sym)
        @order = options[:order].to_sym
      end
      @scale = options[:scale].is_a?(Numeric) ? options[:scale] : auto_scale
    end

    # generates the graph as a String, a visual comparison of the given numbers
    def generate
      # sort steps by either ascending or descending times
      order = @order == :asc ? 1 : -1
      sorted = @names_and_time_ms.sort_by { |(_, time_ms)| time_ms * order }

      # convert times from milliseconds into seconds and add to collection
      sorted.map! { |(name, time_ms)| [name, time_ms, time_ms / 1000.0] }

      # for calculating widths of name and time columns
      longest_name = sorted.map { |(name, _, _)| name.length }.max
      longest_time = sorted.map { |(_, _, time_s)| time_s.to_s.length }.max

      # output line for each name
      sorted.reduce("") do |result, (name, time_ms, time_s)|
        name_column = "#{name}:".rjust(longest_name + 1)
        time_column = "(#{time_s}s)".ljust(longest_time + 3)
        bar_column = "#" * (time_ms / @scale.to_f).ceil
        result + [name_column, time_column, bar_column].join(" ") + "\n"
      end
    end

    private

    def auto_scale
      max_time_ms = @names_and_time_ms.map { |(_, time_ms)| time_ms }.max

      # the idea is to never have the largest value be more than 60 symbols
      if max_time_ms > 60 * 60 * 1000 # use 2 minute scale if greater than 1 hour
        2 * 60 * 1000
      elsif max_time_ms > 60 * 1000 # use minute scale if greater than minute
        60 * 1000
      elsif max_time_ms > 1000 # use seconds scale if greater than second
        1000
      elsif max_time_ms > 10 # use 100 millisecends scale
        100
      else # else milliseconds scale
        1
      end
    end
  end
end
