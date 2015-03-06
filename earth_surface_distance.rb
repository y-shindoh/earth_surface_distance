#! /usr/bin/ruby -Ku
# -*- coding: utf-8; tab-width: 4 -*-
# Author: Yasutaka SHINDOH

class EarthSurfaceDistance
    attr_reader :name, :latitude, :longitude

    LONG_RADIUS = 6378137.0			# 赤道半径 (WGS84)
    SHORT_RADIUS = 6356752.314245	# 極半径 (WGS84)
    ECCENTRICITY = Math::sqrt(((LONG_RADIUS ** 2) - (SHORT_RADIUS ** 2)) / (LONG_RADIUS ** 2))

    def initialize(name, latitude, longitude)
        @name = name	# 地名
        @latitude = latitude / 360.0 * 2.0 * Math::PI	# 緯度 (ラジアン)
        @longitude = longitude / 360.0 * 2.0 * Math::PI	# 経度 (ラジアン)
    end

    def initialize(name, string)
        terms = string.split(/\s*,\s*/)
        @name = name	# 地名
        @latitude = terms[0].to_f / 360.0 * 2.0 * Math::PI	# 緯度 (ラジアン)
        @longitude = terms[1].to_f / 360.0 * 2.0 * Math::PI	# 経度 (ラジアン)
    end

    def EarthSurfaceDistance::Get(from, to)
        # 緯度・経度の差
        delta_latitude = from.latitude - to.latitude
        delta_longitude = from.longitude - to.longitude
        # 緯度の平均値
        average_latitude = (from.latitude + to.latitude) / 2.0
        # 第一離心率
        w = Math::sqrt(1.0 - (ECCENTRICITY ** 2) * (Math::sin(average_latitude) ** 2))
        # 子午線曲率半径
        meridian_curvature_radius = (LONG_RADIUS * (1.0 - (ECCENTRICITY ** 2))) / (w ** 3)
        # 卯酉線曲率半径
        prime_vertical_curvature_radius = LONG_RADIUS / w;
        # 距離
        x = delta_latitude * meridian_curvature_radius
        y = delta_longitude * prime_vertical_curvature_radius * Math::cos(average_latitude)
        return Math::hypot(x, y)
    end
end

if __FILE__ == $PROGRAM_NAME
    buffer = Array::new

    ARGV.each { |v|
        if v.include?(':') then
            term = v.split(/\s*:\s*/)
            buffer << EarthSurfaceDistance::new(term[0], term[1])
        else
            buffer << EarthSurfaceDistance::new(buffer.length.to_s, v)
        end
    }

    total = 0.0

    m = buffer.length - 1
    m.times { |i|
        j = i + 1
        d = EarthSurfaceDistance::Get(buffer[i], buffer[j])
        printf("[%s => %s]\t%f\n", buffer[i].name, buffer[j].name, d)
        total += d
    }

    printf("[TOTAL]\t%f\n", total)
end
