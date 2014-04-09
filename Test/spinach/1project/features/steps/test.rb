class PriceCheckOnEbay < Spinach::FeatureSteps
feature 'price check on eBay'
    Then 'I cleanup' do
       page.cleanup!
    end

  Given 'I navigate to eBay' do
     visit "/"
  end

  And 'I search for "HDMI cable"' do
    fill_in("gh-ac", :with => "HDMI cable")
    page.find("#gh-btn").click
  end
    
  And 'I filter search results by "Buy It Now"' do
    puts current_url
  end
    
  Then 'I list all listed products prices on the page' do
    ppp = current_url
    al = page.all(".ittl .vip").value
    puts al

    #al.each do |i|
    #  page.click_on(i)
    #  sleep 3
    # puts current_url
    # ppp
    #end


  # td[4]/div/div/span
  

    #prices = find_prices
    #puts find_prices

  end
end