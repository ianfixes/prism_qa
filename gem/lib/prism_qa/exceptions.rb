
# PrismQA exceptions

module PrismQA

  # For enforcing the use of certain classes even though they may share a base class
  class IncompatibilityError < TypeError; end

  # For reporting improper extension of the PrismQA base classes (developer error)
  class ImplementationError < RuntimeError; end

  # For reporting assertions that fail at runtime (logic errors in extender's code)
  class OperationalError < RuntimeError; end

end
