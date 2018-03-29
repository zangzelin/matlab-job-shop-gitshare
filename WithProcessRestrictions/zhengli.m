function out = zhengli( gen, P )
    
[m,n] = size( P );
long = length(gen);

zhizhen = ones( m,1 );
count = 1;

out = {};

while( count <= long )
    for i = 1 : long
            cell = gen{ i };
            gongjian = cell( 1 );
            jiqi = cell(2);
%             zhizhen
        if  zhizhen( gongjian ) ~= 8 && P( gongjian, zhizhen( gongjian ) ) == jiqi
            
            out{ count } = gen{ i };
            
            zhizhen( gongjian ) = zhizhen( gongjian )+1;
            count = count + 1;
        end
    end
    
end

end


