function engb = num2english(b,arg)
%  NUM2ENGLISH Convert numbers to plain english.
%
% T = NUM2ENGLISH(X) returns the plain English representation of the
% number X. If X is an array, NUM2ENGLISH returns a cell array the
% same size as the array, with each number in English in the
% corresponding position.
%
% T = NUM2ENGLISH(X,'sci') uses scientific notation.
%     >> NUM2ENGLISH(1.39e5, 'si')
%     ans = 
%         'one point three nine times ten to the fifth'
%
% T = NUM2ENGLISH(X,'si') uses SI multipliers, e.g., 
%     >> NUM2ENGLISH(398600.44, 'si')
%     ans = 
%         'thee hundred ninety-eight point six zero zero four four kilo'
%
% T = NUM2ENGLISH(X,'year') returns a string sounding like a year, e.g.,
%     >> NUM2ENGLISH(1984,'year')
%     ans =
%         'nineteen eighty-four'.
%
%     >> NUM2ENGLISH(1706,'year') 
%     ans = 
%         'seventeen oh-six'.
%
% T = NUM2ENGLISH(X,'th') returns 'first', 'second', 'third' etc.
% instead of 'one', 'two', 'three', etc.
%
% See also strcmp.


% Original by:
% Dave Kellow  (kellowd@mar.dfo-mpo.gc.ca)


% Please report bugs and inquiries to:
%
% Name       : Rody P.S. Oldenhuis
% E-mail     : oldenhuis@gmail.com    (personal)
%              oldenhuis@luxspace.lu  (professional)
% Affiliation: LuxSpace sàrl
% Licence    : BSD


% If you find this work useful, please consider a donation:
% https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6G3S5UYM7HJ3N
    

    %% Initialize
    
    % quick exit
    if isempty(b)
        engb = []; return; end
    
    % Some basic assertions
    assert(isnumeric(b), ...
        'j',...
        'j');    
    if (nargin == 2)
        assert(ischar(arg),...
            'j',...
            'j');
        arg = lower(arg);
    else
        arg = 'normal';
    end
    
    % Initializations based on [arg]    
    switch arg
        case {'n'   'normal'}
            format long
        case {'sci' 'scientific'}
            format long e
        case { 'y'  'year'}
        case {'th'  'count'}
        otherwise
    end
    
    % Static strings
    sing = {'zero' 'one' 'two' 'three' 'four' 'five' 'six' 'seven' 'eight' 'nine'};
    teen = [ { 'ten' 'eleven' 'twelve'} strcat({'thir' 'four' 'fif' 'six' 'seven' 'eigh' 'nine'}, 'teen')];
    doub = [{'zero' 'ten'} strcat({'twen' 'thir' 'four' 'fif' 'six' 'seven' 'eigh' 'nine'}, 'ty')];
    
    hund = 'hundred';
    thou = 'thousand';
    mill = 'million';
    bill = 'billion';
    tril = 'trillion';
           
    large = [{'hundred' 'thousand'} strcat(...
        {'m' 'b' 'tr' 'quadr' 'quint' 'sext' 'sept' 'oct' 'non' 'dec' 'undec' 'duodec',...
        'tredec' 'quattuordec' 'quindec' 'sexdec' 'septendec' 'octodec' 'novemdec' 'vigint'},...
        'illion')];
    small = strcat(large, 'th');    
    
    singth = [{'zeroth' 'first' 'second' 'third'} strcat({'four' 'fif' 'six' 'seven' 'eigh' 'nin'}, 'th')];
    teenth = [strcat(teen(1:2), 'th') 'twelfth' strcat(teen(4:end), 'th')];
    doubth = [{'zeroth' 'tenth'} strcat({'twen' 'thir' 'four' 'fif' 'six' 'seven' 'eigh' 'nine'}, 'tieth')];
    
    hundth = 'hundredth';
    thouth = 'thousandth';
    millth = 'millionth';
    billth = 'billionth';
    trilth = 'trillionth';
    
    point = 'point';
     
    
    %% 
    
    engb = cell(size(b));
    for nlq = 1:numel(b)
        a = b(nlq);
        
        % Handle negative numbers
        neg_sect = '';
        if a<0
            neg_sect = 'minus ';
            a = abs(a);
        end
            
        % Years
        if strcmp(arg,'year')
            
            stryear = num2str(fix(a));
            if length(stryear)>2
                firstpart = zero2999(str2double(stryear(1:end-2)));
                
                
                secondpart = zero2999(str2double(stryear(end-1:end)));
                if str2double(stryear(end-1:end))>0 && str2double(stryear(end-1:end))<10
                    secondpart = ['oh-',secondpart];
                end
                
                
                engy = [firstpart,' ',secondpart];
                
                if ~isempty(neg_sect)
                engy = [engy ' BC']; end
                
            end
        end
        
        % Numerals
        if ~strcmp(arg,'th')
            th = 0;
        else
            th = 1;
        end
                
        
        if a > 999999999999999
            error('This utility doesn''t do quadrillions or higher. Yet.');
        end
        
        stra = num2str(a);
        qqq = 4;
        while str2double(stra)~=a
            qqq  = qqq+1;
            stra = num2str(a,qqq);
        end
        
        
        pq = findstr('.', stra);
        if ~isempty(pq)
            if th
                error('Can''t do decimalth numbers; integers only.'); end
            
            decimal_portion = [' ' point ' '];
            for l = pq+1:length(stra)
                decimal_portion = [decimal_portion,char(sing{str2double(stra(l))+1}),' '];
            end
            stra_int = stra(1:pq-1);
        else
            decimal_portion = [];
            stra_int = stra;
        end
        
        Q = length(stra_int);
        integer_portion=[];
        
        if Q>12
            integer_portion = [zero2999(str2double(stra_int(1:end-12))) ' ' tril];
            if str2double(stra_int(end-11:end-2))>0
                integer_portion = [integer_portion ', '];
            elseif str2double(stra_int(end-1:end))>0
                integer_portion = [integer_portion ' '];
            else
                integer_portion = [integer_portion ' '];
            end
            if str2double(stra_int(end-11:end))==0 && th
                integer_portion = strrep(integer_portion,tril,trilth);
            end
            
            
        end
        
        if Q>9 && str2double(stra_int(max(1,end-11):end-9))
            integer_portion = [integer_portion, zero2999(str2double(stra_int(max(1,end-11):end-9))) ' ' bill];
            if str2double(stra_int(end-8:end-2))>0
                integer_portion = [integer_portion ', '];
            elseif str2double(stra_int(end-1:end))>0
                integer_portion = [integer_portion ' '];
            else
                integer_portion = [integer_portion ' '];
            end
            if str2double(stra_int(end-8:end))==0 && th
                integer_portion = strrep(integer_portion,bill,billth);
            end
            
        end
        
        if Q>6 && str2double(stra_int(max(1,end-8):end-6))
            integer_portion = [integer_portion, zero2999(str2double(stra_int(max(1,end-8):end-6))) ' ' mill];
            if str2double(stra_int(end-5:end-2))>0
                integer_portion = [integer_portion ', '];
            elseif str2double(stra_int(end-1:end))>0
                integer_portion = [integer_portion ' '];
            else
                integer_portion = [integer_portion ' '];
            end
            if str2double(stra_int(end-5:end))==0 && th
                integer_portion = strrep(integer_portion,mill,millth);
            end
        end
        
        if Q>3 && str2double(stra_int(max(1,end-5):end-3))>0
            integer_portion = [integer_portion, zero2999(str2double(stra_int(max(1,end-5):end-3))) ' ' thou];
            if str2double(stra_int(end-2))>0
                integer_portion = [integer_portion ', '];
            elseif str2double(stra_int(end-1:end))>0
                integer_portion = [integer_portion ' '];
            else
                integer_portion = [integer_portion ' '];
            end
            if str2double(stra_int(end-2:end))==0 && th
                integer_portion = strrep(integer_portion,thou,thouth);
            end
        end
        
        if str2double(stra_int(max(1,end-2):end))>0
            integer_portion = [integer_portion,zero2999(str2double(stra_int(max(1,end-2):end)),th)];
        elseif str2double(stra_int)==0 && ~isempty(decimal_portion)
            integer_portion = [integer_portion,zero2999(str2double(stra_int(max(1,end-2):end)))];
        elseif str2double(stra_int)==0 && isempty(decimal_portion)
            integer_portion = 'zero ';
            if th
                integer_portion = 'zeroth';
            end
        end
        
        eng = [neg_sect  integer_portion  decimal_portion];        
        if strcmp(arg,'year')
            engy = strrep(engy,'zero','oh-oh');
            engb{nlq} = engy;
        else
            engb{nlq} = eng;
        end
        
    end
    
    if numel(b) == 1
        engb = engb{1}; end
    
    engb = regexprep(strtrim(engb), '\s{2,}', ' ');
      
    
    
    function zero2999str = zero2999(num,th)
       
        if nargin==1
            th = 0; end



        stra_int2 = num2str(num);
        
        switch length(num2str(num));
            case 1
                hundred_portion = [];
                zero2999str = [sing{num+1}];
                if th
                    zero2999str = singth{num+1}; end

            case 2
                last_two = str2double(stra_int2(1:2));
                if last_two==0
                    zero2999str = [];
                elseif last_two<10 && last_two>0
                    zero2999str = [sing{last_two+1}];
                    if th
                        zero2999str = [singth{last_two+1}]; end

                elseif last_two<20 && last_two>9
                    zero2999str = teen{last_two-9};
                    if th
                        zero2999str = teenth{last_two-9}; end

                else
                    last_two_str = num2str(last_two);
                    last_two_tens = str2double(last_two_str(1));
                    last_two_ones = str2double(last_two_str(2));
                    last_two_tens_portion = doub{last_two_tens+1};
                    if last_two_ones>0
                        last_two_ones_portion = ['-',sing{last_two_ones+1}];
                        if th
                            last_two_ones_portion = ['-',singth{last_two_ones+1}];
                        end
                    else
                        last_two_ones_portion = [];
                        if th
                            last_two_tens_portion = doubth{last_two_tens+1};
                        end
                    end
                    zero2999str = [last_two_tens_portion,last_two_ones_portion];
                end
            case 3
                hundred_portion = [char(sing{str2double(stra_int2(1))+1}),' ',hund];
                last_two = str2double(stra_int2(2:3));
                if last_two==0
                    zero2999str = [hundred_portion];
                    if th
                        zero2999str = [char(sing{str2double(stra_int2(1))+1}),' ',hundth];
                    end
                elseif last_two<10 && last_two>0
                    zero2999str = [hundred_portion,' ',sing{last_two+1}];
                    if th
                        zero2999str = [hundred_portion,' ',singth{last_two+1}];
                    end

                elseif last_two<20 && last_two>9
                    zero2999str = [hundred_portion,' ',teen{last_two-9}];
                    if th
                        zero2999str = [hundred_portion,' ',teenth{last_two-9}];
                    end

                else
                    last_two_str = num2str(last_two);
                    last_two_tens = str2double(last_two_str(1));
                    last_two_ones = str2double(last_two_str(2));
                    last_two_tens_portion = doub{last_two_tens+1};
                    if last_two_ones>0
                        last_two_ones_portion = ['-',sing{last_two_ones+1}];
                        if th
                            last_two_ones_portion = ['-',singth{last_two_ones+1}];
                        end
                    else
                        last_two_ones_portion = [];
                        if th
                            last_two_tens_portion = doubth{last_two_tens+1};
                        end
                    end
                    zero2999str = [hundred_portion,' ',last_two_tens_portion,last_two_ones_portion];
                end
        end

    end

    
    
    
    
    
    
 
end



