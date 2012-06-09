module ApplicationHelper
  include ActionView::Helpers::TextHelper
  
  # Page title ------------------------------------------------------
  
  def title(page_title = '')
    if page_title.blank?
      content_for(:title) { APP_CONFIG['site_name'] }
    else
      content_for(:title) {"#{APP_CONFIG['site_name']} &#8594; #{page_title}"}
    end
  end

  # Different helpers ---------------------------------------------------
  
  def approved_color(approved)
    approved ? "approved" : "not_approved"
  end
  
  def user_name(user)
    user.name.blank? ? user.login : user.name      
  end

  def date(date)
    if date < 24.hours.since(Time.now.midnight) and date > Time.now.midnight
      Russian::strftime(date, "Сегодня %H:%M")
    elsif date > Time.now.at_beginning_of_month and date < Time.now.midnight
      Russian::strftime(date, "%d %B")
    else
      Russian::strftime(date, "%d %B %Y")
    end
  end
  
  # Bars ------------------------------------------------------------
  
  def user_bar
    render :partial => "shared/bars/user"
  end
  
  def search_bar
    render :partial => "shared/bars/search"
  end
  
  def admin_search_bar
    render :partial => "shared/bars/admin_search"
  end
  
  # Menus -----------------------------------------------------------
  
  def org_menu(tab = 'cart')
    render :partial => "shared/menus/org", :locals => {:current => tab}
  end

  def admin_menu(tab = 'main')
    render :partial => "shared/menus/admin", :locals => {:current => tab}
  end
  
  def admin_org_menu(tab = 'cart')
    render :partial => "shared/menus/admin_org", :locals => {:current => tab}
  end
  
  def admin_user_menu(tab = 'profile')
    render :partial => "shared/menus/admin_user", :locals => {:current => tab}
  end
  
  def user_menu(tab = "index")
    render :partial => "shared/menus/user", :locals => {:current => tab}
  end
  
  # Page elements ---------------------------------------------------

  def stat_panel
    content_tag(:div, content_tag(:h3, "Статистика сервиса") + content_tag(:p, "Организаций: #{Org.count}") + content_tag(:p, "Телефонов: #{Phone.count}") + content_tag(:p, "Категорий: #{Category.count}"), :class => "stat round-10")
  end

  def footer 
    result = ""   
    links = [link_to("Помощь", help_path), "  •  ", 
             link_to("Условия использования", terms_path), "  •  ",
             link_to("Реклама на сайте", advertising_path), "  •  ",
             link_to("Связаться с нами", contact_us_path)]             
    result << content_tag(:div, "&copy; 2009, #{link_to 'tkmk.info', 'http://tkmk.info'} Все права защищены", :class => "copiright") 
    result << content_tag(:div, links, :class => "more-links")    
    links = [link_to("Valid XHTML 1.0", "http://validator.w3.org/check?uri=referer", :class => "valid_link", :target => "_blank"),"  •  ",
             link_to("Ruby on Rails", "http://rubyonrails.org", :class => "ruby_link", :target => "_blank")]
    result << content_tag(:div, links, :class => "more-links")
  end
  
  def messages
    render :partial => "shared/messages/flash"
  end
    
  def auth_notice(msg = "Зарегистрируйтесь или авторизуйтесь")
    content_tag(:div, msg, :class => "auth_notice round-10")
  end
  
  def tags(count)
    tags = []
    Tag.cloud(count).each do |tag|
      tags << link_to(tag[:name], tag_path(:id => tag[:id]), :class => "round-10 tip", :id => "tag_#{tag[:id]}", :title => "Организации с тэгом #{tag[:name]}")  + "\n"
    end
    tags.to_s
  end
  
  def back_link(*items)
    links = []
    items.each do |item|
      case item
        when :back then links << link_to("&lt;&lt; Вернутся назад", "", {:href => "javascript:history.back();"})
        when :orgs then links << link_to("Перейти к организациям &gt;&gt;", backend_orgs_path)
        when :towns then links << link_to("... к городам &gt;&gt;", backend_towns_path )
        when :streets then links << link_to("... к улицам &gt;&gt;", backend_streets_path)
        when :categories then links << link_to("... к категориям &gt;&gt;", backend_categories_path)
        when :tags then links << link_to(".... к тэгам &gt;&gt;", backend_tags_path)
        when :associations then links << link_to("... к ассоциациям &gt;&gt;", backend_associations_path)
        when :requests then links << link_to(".... к запросам &gt;&gt; ", backend_requests_path)
        when :rewiews then links << link_to(".... к отзывам &gt;&gt; ", backend_rewiews_path)
        when :roles then links << link_to(".... к ролям &gt;&gt; ", backend_roles_path)
        when :users then links << link_to(".... к пользователям &gt;&gt; ", backend_users_path)
      end
    end
    content_tag(:div, links, :class => "back_link")
  end
  
  # TODO: Написать тесты оставашихся функций хелпера
  
  def multiple_select_categories 
    items = []
    Category.get_parent_categories.each do |category|
      subitems = []
      category.children.each do |subcategory|
        subitems << content_tag(:span, check_box_tag( "activities[]", subcategory.id, false, :id => "activity_#{subcategory.id}") + subcategory.name + "<br />", :class => "subcategory", :title => subcategory.name )
      end
      items << content_tag(:p, category.name, :class => "category") + subitems.to_s
    end
    content_tag(:div, items, :class => "list_checkbox")
  end
  
  def group_select_category(selected)
    @categories     = Category
    render :partial => "shared/elements_form/group_select", :locals => {:selected => selected}
  end
  
  def select_category(selected = "")
    @categories     = Category.root.children
    render :partial => "shared/elements_form/select_category", :locals => {:categories => @categories, :selected => selected}
  end

  def tree_categories_and_subcategories
    @current        = params[:id].to_i
    @categories     = Category.root.children
    @curr_category  = Category.find(@current)
    @parent         = @curr_category.parent_id
    if @parent == 1
      @subcategories  = @curr_category.children    
    else
      @parent_category  = Category.find(@parent)
      @subcategories  = @parent_category.children
    end
      render :partial => "shared/elements_page/tree_categories_and_subcategories"
  end
  
  def categories
    @categories     = Category.get_parent_categories
    @subcategories  = Category.get_subcategories_of_first_category
    render :partial => "shared/elements_page/categories"
  end
  
  def backend_categories
    @categories     = Category.get_parent_categories
    @subcategories  = Category.get_subcategories_of_first_category
    render :partial => "categories"
  end
  
  def org_rows(orgs, page)
    content = []
    count = orgs.length
    page > 1 ? start_num = 10 * (page-1) : start_num = 0 
    orgs.each_with_index do |org, i|
      result = []
      items = []
      result << content_tag(:h3, link_to(truncate(org.name, :ommision => "...", :length => 80), org_path(org)))
      items << content_tag(:span, org.town.name, :class => "town")
      unless org.street.name.blank? 
        items << content_tag(:span, "&#8594; ул. #{org.street.name}", :class => "street") 
      end      
      unless org.house.blank? 
        items << content_tag(:span, "/#{org.house}", :class => "house") 
      end
      result << content_tag(:div, items.to_s, :class => "adress")
      items.clear
      unless org.email.blank? 
        items << content_tag(:span, mail_to(org.email, "Написать письмо", :encode => "hex"), :class => "email")
      end
      unless org.www.blank?       
        items << content_tag(:span, link_to("Веб-сайт", org.www, :target => "_blank", :title => "Откроется в новом окне"), :class => "www")
      end
      items << content_tag(:span, link_to("Позвонить", org_phones_path(org)))
      items << content_tag(:span, :class => "user_area", :style => "display:none;") do 
        content_tag(:span, 
                    link_to_remote("Добавить в избранное", {:url => org_favorites_path(org, :format => "js"), :method => "post"}, :href => org_favorites_path(org)), 
                    :class => "favorite")
      end    
      result << content_tag(:div, items.to_s, :class => "additional")
      class_str = ""
      class_str << ' first' if i == 0
      class_str << ' last' if i == count-1
      class_str << ' recommended' if org.recommended
      content << content_tag(:div, content_tag(:div, start_num + i + 1, :class => "num") + content_tag(:div, result.to_s, :class => "info"), :class => "org-box tip-org#{class_str.to_s}", :title => (org.description if !org.description.blank?)) + "\n"
    end
    content.to_s
  end
  
  def google_analitics
    if ENV["RAILS_ENV"] == 'production'
      "<script type=\"text/javascript\">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-17022263-3']);
        _gaq.push(['_trackPageview']);
        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      </script>"
    end
  end

  def ga_stat_graffic(data)    
    chart_1 = ""
    chart_2 = ""
    @data.each do |value|
      date_pattern = /(\d{4})(\d{2})(\d{2})/
      date = date_pattern.match(value.date)
      chart_1 << "['#{date[3]}', #{value.visits}]," 
      chart_2 << "['#{date[3]}', #{value.pageviews}]," 
    end

    "<script src='http://www.google.com/jsapi' type='text/javascript'></script>
    <script type='text/javascript'>
      google.load('visualization', '1', {packages:['corechart']});
      google.setOnLoadCallback(drawChart);      
      function drawChart() {
        var chart_data_1 = new google.visualization.DataTable();
            chart_data_1.addColumn('string', 'Дата');
            chart_data_1.addColumn('number', 'Посетители');
        var chart_data_2 = new google.visualization.DataTable();
            chart_data_2.addColumn('string', 'Дата');
            chart_data_2.addColumn('number', 'Просмотры');
        chart_data_1.addRows([#{chart_1}]);
        chart_data_2.addRows([#{chart_2}]);        
        var chart_1 = new google.visualization.AreaChart(document.getElementById('chart1'));
        chart_1.draw(chart_data_1, {width: 450, height: 250, legend: 'none'});        
        var chart_2 = new google.visualization.AreaChart(document.getElementById('chart2'));
        chart_2.draw(chart_data_2, {width: 450, height: 250, legend: 'none'});
      }
    </script>"
  end 
  
  def google_map(markers, edit = true)
    
    markers_code = Array.new
    unless markers.blank?
      markers.each do |marker|
        markers_code << "{ latitude: #{marker.latitude}, longitude: #{marker.longtitude}#{(", html: '" + marker.name + "'") unless marker.name.blank?} }"
      end
    end       
        
    editable_code = <<-EOF
    function click_callback(marker){
      function update_coordinates(marker){
        jQuery('#position_' + marker.__gm_id).html(marker.position.c.toFixed(2) + '&#176; | ' + marker.position.b.toFixed(2) + '&#176;');
  			jQuery('#latitude_' + marker.__gm_id).val(marker.position.b); 
  		  jQuery('#longtitude_' + marker.__gm_id).val(marker.position.c);
      };
      jQuery('<div id=\"marker_' + marker.__gm_id + '\" class=\"marker\"><input id=\"name_' + marker.__gm_id + '\" class=\"name_markers\" name=\"markers[][name]\" size=\"30\" type=\"text\"/><div class=\"position\" id=\"position_' + marker.__gm_id + '\"></div><input type=\"hidden\" id=\"latitude_' + marker.__gm_id + '\" name=\"markers[][latitude]\" /><input type=\"hidden\" id=\"longtitude_' + marker.__gm_id + '\" name=\"markers[][longtitude]\" /></div>').appendTo('#markers'); 
			update_coordinates(marker)
			google.maps.event.addListener(marker, 'drag', function() { 
			  update_coordinates(marker)
			  jQuery('.name_markers').css('border', '');
			  jQuery('#name_' + marker.__gm_id).css('border', '1px solid #c00'); 
			});
			google.maps.event.addListener(marker, 'click', function() { 
			  jQuery('.name_markers').css('border', '');
			  jQuery('#name_' + marker.__gm_id).css('border', '1px solid #c00'); 
			});
    };
    function dblclick_callback(marker){
      jQuery('#marker_' + marker.__gm_id).remove();
    };
    EOF
    
    "<script src='http://maps.google.com/maps/api/js?sensor=false' type='text/javascript'></script>
    #{javascript_include_tag "jquery-gomap"}
    <script type='text/javascript'> 
      jQuery(function() { 
        jQuery('#map').goMap({ 
          markers:[#{markers_code.join(",")}],
          latitude: 47.248475, longitude: 35.702477, zoom: 13,
          mapTypeControl: true, mapTypeControlOptions: { position: 'RIGHT', style: 'DROPDOWN_MENU' },
          icon: '#{image_path("marker.png")}' #{", addMarker: true, disableDoubleClickZoom: true" if edit}
        });
      });#{editable_code if edit}
    </script>"    
  end 
  
  def google_map_admin(markers)

    markers_code = Array.new
    unless markers.blank?
      markers.each do |marker|
        markers_code << "{ latitude: #{marker.latitude}, longitude: #{marker.longtitude}, draggable: true, html: { id: '#marker_#{marker.id}' } }"
      end
    end       

    "<script src='http://maps.google.com/maps/api/js?sensor=false' type='text/javascript'></script>
    #{javascript_include_tag "jquery-gomap"}
    <script type='text/javascript'> 
      jQuery(function() { 
        jQuery('#map').goMap({ 
          markers:[#{markers_code.join(",")}],
          latitude: 47.248475, longitude: 35.702477, zoom: 13,
          mapTypeControl: true, mapTypeControlOptions: { position: 'RIGHT', style: 'DROPDOWN_MENU' },
          icon: '#{image_path("marker.png")}', addMarker: true, disableDoubleClickZoom: true
        });
      });      
      function click_callback(marker){
        function update_coordinates(marker){
          jQuery('#position_' + marker.__gm_id).html(marker.position.c.toFixed(2) + '&#176; | ' + marker.position.b.toFixed(2) + '&#176;');
    			jQuery('#latitude_' + marker.__gm_id).val(marker.position.b); 
    		  jQuery('#longtitude_' + marker.__gm_id).val(marker.position.c);
        };
        jQuery('<div id=\"marker_' + marker.__gm_id + '\" class=\"marker\"><input id=\"name_' + marker.__gm_id + '\" class=\"name_markers\" name=\"markers[][name]\" size=\"30\" type=\"text\"/><div class=\"position\" id=\"position_' + marker.__gm_id + '\"></div><input type=\"hidden\" id=\"latitude_' + marker.__gm_id + '\" name=\"markers[][latitude]\" /><input type=\"hidden\" id=\"longtitude_' + marker.__gm_id + '\" name=\"markers[][longtitude]\" /></div>').appendTo('#markers'); 
    		update_coordinates(marker)
    		google.maps.event.addListener(marker, 'drag', function() { 
    		  update_coordinates(marker)
    		  jQuery('.name_markers').css('border', '');
    		  jQuery('#name_' + marker.__gm_id).css('border', '1px solid #c00'); 
    		});
    		google.maps.event.addListener(marker, 'click', function() { 
    		  jQuery('.name_markers').css('border', '');
    		  jQuery('#name_' + marker.__gm_id).css('border', '1px solid #c00'); 
    		});
      };
      function dblclick_callback(marker){
        jQuery('#marker_' + marker.__gm_id).remove();
      };
    </script>"    
  end 
  
end

