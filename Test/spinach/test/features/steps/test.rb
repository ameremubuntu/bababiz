class Test < Spinach::FeatureSteps
feature 'Test'
  Then 'I cleanup' do
    page.cleanup!
  end

  Given 'I do first' do
    visit '/'
    
  end

  Then 'I do second' do
    puts current_url
  end  

  And 'I do third' do
    
  end



  When 'I do fourth' do
    

  end


  And 'I do fifth' do
    
  end

  When 'I do sixth' do
    
  end
  
  Then 'I cleanup' do
    page.cleanup!
  end
  
  
  
  
  
  
  
  
  
  
  
  
end




