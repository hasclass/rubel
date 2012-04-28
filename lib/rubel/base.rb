module Rubel
  RuntimeEnvironment = Runtime::Loader.runtime
  class Base < RuntimeEnvironment
    include ::Rubel::Functions::Defaults    
  end
end
