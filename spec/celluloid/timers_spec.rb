require 'spec_helper'

describe Celluloid::Timers do
  before :each do
    @timers = Celluloid::Timers.new
  end

  it "sleeps until the next timer" do
    interval = 0.1
    started_at = Time.now

    fired = false
    @timers.add(interval) { fired = true }
    @timers.wait

    fired.should be_true
    (Time.now - started_at).should be_within(Celluloid::Timer::QUANTUM).of interval
  end

  it "it calculates the interval until the next timer should fire" do
    interval = 0.1

    @timers.add(interval)
    @timers.wait_interval.should be_within(Celluloid::Timer::QUANTUM).of interval
  end

  it "fires timers in the correct order" do
    result = []

    Q = Celluloid::Timer::QUANTUM

    @timers.add(Q * 2) { result << :two }
    @timers.add(Q * 3) { result << :three }
    @timers.add(Q * 1) { result << :one }

    sleep 0.03 + Celluloid::Timer::QUANTUM
    @timers.fire

    result.should == [:one, :two, :three]
  end
end
