def declare(example_name, method:, expected:)
  shared_examples example_name do
    it example_name do
      expect(subject.send(method)).to be expected
    end
  end
end

declare 'x > y', method: :greater?, expected: true
declare '!(x > y)', method: :greater?, expected: false

declare 'x >= y', method: :greater_or_equal?, expected: true
declare '!(x >= y)', method: :greater_or_equal?, expected: false

declare 'x == y', method: :equality?, expected: true
declare '!(x == y)', method: :equality?, expected: false

declare 'x <= y', method: :less_or_equal?, expected: true
declare '!(x <= y)', method: :less_or_equal?, expected: false

declare 'x < y', method: :less?, expected: true
declare '!(x < y)', method: :less?, expected: false

declare 'x != y', method: :inequality?, expected: true
declare '!(x != y)', method: :inequality?, expected: false

