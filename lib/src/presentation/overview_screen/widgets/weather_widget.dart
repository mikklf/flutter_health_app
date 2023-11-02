import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_app/src/logic/cubit/weather_cubit.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.read<WeatherCubit>().loadCurrentWeather();
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state.weatherData == null) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              _buildHeader(context, state),
              const SizedBox(height: 16),

              _buildTemperature(context, state.weatherData?.temperature),
              const SizedBox(height: 8),

              _buildFeelsLikeTemp(context, state.weatherData?.temperatureFeelsLike),
              const SizedBox(height: 8),

              _buildHumidity(context, state.weatherData?.humidity),
              const SizedBox(height: 8),

              _buildCloudiness(context, state.weatherData?.cloudinessPercent),
              const SizedBox(height: 8),


              _buildSunUpAt(context, state.weatherData?.sunrise),
              const SizedBox(height: 8),

              _buildSunDownAt(context, state.weatherData?.sunset),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildTemperature(BuildContext context, num? temperature) {
        String feelsLikeTempString = temperature != null
        ? "${temperature.toStringAsFixed(0)} °C"
        : "N/A";

    return _buildDataPoint(context, "Temperature", feelsLikeTempString, Icons.thermostat_outlined);
  }
  
  Widget _buildFeelsLikeTemp(BuildContext context, num? feelsLikeTemp) {
    String feelsLikeTempString = feelsLikeTemp != null
        ? "${feelsLikeTemp.toStringAsFixed(0)} °C"
        : "N/A";

    return _buildDataPoint(context, "Feels like", feelsLikeTempString, Icons.thermostat_outlined);
  }

  Widget _buildHumidity(BuildContext context, num? humidity) {
    String humidityString = humidity != null
        ? "${humidity.toStringAsFixed(0)} %"
        : "N/A";

    return _buildDataPoint(context, "Humidity", humidityString, Icons.water_outlined);
  }

  Widget _buildCloudiness(BuildContext context, num? cloudinessPercent) {
    String cloudinessPercentString = cloudinessPercent != null
        ? "${cloudinessPercent.toStringAsFixed(0)} %"
        : "N/A";

    return _buildDataPoint(context, "Cloudiness", cloudinessPercentString, Icons.cloud_outlined);
  }


  Widget _buildSunUpAt(BuildContext context, DateTime? sunrise) {
    String sunriseString = sunrise != null
        ? "${sunrise.hour.toString().padLeft(2, '0')}:${sunrise.minute.toString().padLeft(2, '0')}"
        : "N/A";

    return _buildDataPoint(context, "Sun up at", sunriseString, Icons.sunny);
  }

  Widget _buildSunDownAt(BuildContext context, DateTime? sunset) {
    String sunsetString = sunset != null
        ? "${sunset.hour.toString().padLeft(2, '0')}:${sunset.minute.toString().padLeft(2, '0')}"
        : "N/A";

    return _buildDataPoint(context, "Sun down at", sunsetString, Icons.nightlight_round);
  }

  Row _buildDataPoint(
      BuildContext context, String title, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 4),
            Icon(icon, size: 16),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                //Text("Last hour", style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WeatherState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.cloud_circle_rounded),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weather", style: Theme.of(context).textTheme.titleLarge),
                Text("Last hour", style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
        Text(state.weatherData!.weatherdescription ?? "",
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
