require 'test_helper'

class ExecutionAnalyzerTest < Minitest::Test

  @@example_executions = [
    {
      id: 1,
      steps: [
        {name: "step1", timeMs: 5000},
        {name: "step2", timeMs: 1000},
        {name: "step3", timeMs: 30000},
        {name: "step4", timeMs: 10000}
      ]
    },
    {
      id: 2,
      steps: [
        {name: "step1", timeMs: 5000},
        {name: "step2", timeMs: 1000},
        {name: "step3", timeMs: 20000},
        {name: "step4", timeMs: 15000}
      ]
    },
    {
      id: 3,
      steps: [
        {name: "step1", timeMs: 5000},
        {name: "step2", timeMs: 1000},
        {name: "step3", timeMs: 40000},
        {name: "step4", timeMs: 50000}
      ]
    }
  ]

  def setup
    @analyzer = ::HistogramBuilder::ExecutionAnalyzer.new(@@example_executions)
  end

  def test_step_times
    assert_equal(
      {
        "step1" => [5000, 5000, 5000],
        "step2" => [1000, 1000, 1000],
        "step3" => [30000, 20000, 40000],
        "step4" => [10000, 15000, 50000]
      },
      @analyzer.step_times
    )
  end

  def test_medians
    assert_equal(
      [
        ["step1", 5000],
        ["step2", 1000],
        ["step3", 30000],
        ["step4", 15000]
      ],
      @analyzer.medians
    )
  end
end
