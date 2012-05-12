task 'test' do
    sh 'ruby ' + File.dirname(__FILE__) + '/test/app_test.rb'
    Dir['./test/scripts/*test.rb'].each do |file|
        test_file = File.basename file
        sh 'cd test/scripts; ruby ' + test_file
    end
end
